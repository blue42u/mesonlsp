#pragma once

#include "utils.hpp"
#include "wrap.hpp"

#include <cstring>
#include <filesystem>
#include <fstream>
#include <memory>
#include <string>
#include <utility>

class MesonSubproject {
public:
  bool initialized = false;
  std::string name;
  std::filesystem::path realpath;

  MesonSubproject(std::string name, std::filesystem::path path)
      : name(std::move(name)), realpath(std::move(path)) {}

  virtual void init() = 0;
  virtual void update() = 0;

  virtual ~MesonSubproject() = default;
};

class CachedSubproject : public MesonSubproject {
public:
  CachedSubproject(std::string name, std::filesystem::path path)
      : MesonSubproject(std::move(name), std::move(path)) {
    this->initialized = true;
  }

  void init() override {
    // Nothing
  }

  void update() override {
    // Nothing
  }
};

class FolderSubproject : public MesonSubproject {
public:
  FolderSubproject(std::string name, std::filesystem::path path)
      : MesonSubproject(std::move(name), std::move(path)) {
    this->initialized = true;
  }

  void init() override {
    // Nothing
  }

  void update() override {
    // Nothing
  }
};

// TODO: Move me
static std::string
guessTargetDirectoryFromWrap(const std::filesystem::path &path) {
  if (std::filesystem::exists(path)) {
    std::ifstream file(path.c_str());
    std::string line;
    while (std::getline(file, line)) {
      size_t pos = line.find("directory");
      if (pos != std::string::npos) {
        auto directoryValue = line.substr(pos + strlen("directory"));
        trim(directoryValue);
        if (directoryValue.empty() || directoryValue[0] != '=') {
          continue;
        }
        auto withoutEquals = directoryValue.substr(1);
        trim(withoutEquals);
        return withoutEquals;
      }
    }
  }
  return path.filename().stem().string();
}

class WrapSubproject : public MesonSubproject {
public:
  std::filesystem::path wrapFile;
  std::filesystem::path packageFiles;
  std::shared_ptr<WrapFile> wrap;

  WrapSubproject(std::string name, std::filesystem::path wrapFile,
                 std::filesystem::path packageFiles, std::filesystem::path path)
      : MesonSubproject(std::move(name),
                        path / guessTargetDirectoryFromWrap(wrapFile)),
        wrapFile(std::move(wrapFile)), packageFiles(std::move(packageFiles)) {}

  void init() override {
    auto ptr = parseWrap(this->wrapFile);
    if (!ptr || !ptr->serializedWrap) {
      return;
    }
    auto result = ptr->serializedWrap->setupDirectory(
        this->realpath.parent_path(), this->packageFiles);
    if (!result) {
      return;
    }
    this->initialized = true;
  }

  void update() override {
    // Nothing
  }
};
