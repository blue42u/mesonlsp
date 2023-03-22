import Foundation
import IOUtils
import Logging

public class Wrap {
  private static let LOG: Logger = Logger(label: "Wrap::Wrap")
  public private(set) var directory: String?
  public private(set) var patchURL: String?
  public private(set) var patchFallbackURL: String?
  public private(set) var patchFilename: String?
  public private(set) var patchHash: String?
  public private(set) var patchDirectory: String?
  public private(set) var diffFiles: [String]?
  public private(set) var provides: Provides = Provides()
  public private(set) var wrapFile: String = ""

  internal init(
    directory: String?,
    patchURL: String?,
    patchFallbackURL: String?,
    patchFilename: String?,
    patchHash: String?,
    patchDirectory: String?,
    diffFiles: [String]?
  ) {
    self.directory = directory
    self.patchURL = patchURL
    self.patchFallbackURL = patchFallbackURL
    self.patchFilename = patchFilename
    self.patchHash = patchHash
    self.patchDirectory = patchDirectory
    self.diffFiles = diffFiles
  }

  internal func applyProvides(_ provides: Provides) { self.provides = provides }

  internal func setFile(_ file: String) { self.wrapFile = file }

  public func setupDirectory(path: String, packagefilesPath: String) throws {
    fatalError("Implement me")
  }

  internal func assertRequired(_ command: String) throws {
    let task = Process()
    Self.LOG.info("Checking if `\(command)` exists")
    task.arguments = ["-c", "which \(command)"]
    task.executableURL = URL(fileURLWithPath: "/bin/sh")
    try task.run()
    task.waitUntilExit()
    if task.terminationStatus != 0 {
      throw WrapError.commandNotFound("Required command `\(command)` not found")
    }
  }

  internal func executeCommand(_ commands: [String], _ cwd: String? = nil) throws {
    let task = Process()
    let joined = commands.map { "\'\($0)\'" }.joined(separator: " ")
    Self.LOG.info("Executing \"\(joined)\" at \(cwd ?? "???")")
    task.arguments = ["-c", "\(joined)"]
    task.executableURL = URL(fileURLWithPath: "/bin/sh")
    if let c = cwd { task.currentDirectoryURL = URL(fileURLWithPath: c) }
    try task.run()
    task.waitUntilExit()
    if task.terminationStatus != 0 {
      throw WrapError.genericError("Command failed with code \(task.terminationStatus): \(joined)")
    }
  }

  internal func download(url: String) throws -> String {
    let tempPath = FileManager.default.temporaryDirectory.standardizedFileURL.path
    let outputFile = tempPath + "/" + UUID().uuidString
    var found = false
    Self.LOG.info("Attempting to download from \(url) to file \(outputFile)")
    do {
      try self.assertRequired("wget")
      found = true
      try self.executeCommand(["wget", url, "-O", outputFile, "-q", "-o", "/dev/stderr"])
    } catch {
      if !found {
        try self.assertRequired("curl")
        try self.executeCommand(["curl", url, "-o", outputFile, "-s"])
      } else {
        throw error
      }
    }
    return outputFile
  }

  internal func postSetup(path: String, packagesfilesPath: String) throws {
    try self.applyPatch(path: path, packagesfilesPath: packagesfilesPath)
    try self.applyDiffFiles(path: path, packagesfilesPath: packagesfilesPath)
  }

  func applyPatch(path: String, packagesfilesPath: String) throws {
    if let patchDir = self.patchDirectory {
      let packagePath = Path(packagesfilesPath + "/" + patchDir)
      Self.LOG.info("Copying from \(packagePath) to \(path)")
      let children = try packagePath.children()
      let destDir = Path(path)
      try mergeDirectories(
        from: URL(fileURLWithPath: packagePath.description),
        to: URL(fileURLWithPath: path)
      )
      return
      for c in children {
        do { try c.copy(destDir) } catch let e {
          Self.LOG.warning("\(e)")
          throw e
        }
      }
    }
  }

  func applyDiffFiles(path: String, packagesfilesPath: String) throws {}

  func mergeDirectories(from sourceURL: URL, to destinationURL: URL) throws {
    let fileManager = FileManager.default
    let fileUrls = try fileManager.contentsOfDirectory(
      at: sourceURL,
      includingPropertiesForKeys: nil
    )

    for fileUrl in fileUrls {
      let destinationFileUrl = destinationURL.appendingPathComponent(fileUrl.lastPathComponent)
      if fileManager.fileExists(atPath: destinationFileUrl.path) {
        try fileManager.removeItem(at: destinationFileUrl)
      }
      if fileManager.fileExists(atPath: fileUrl.path) {
        if fileUrl.hasDirectoryPath {
          try fileManager.createDirectory(
            at: destinationFileUrl,
            withIntermediateDirectories: true,
            attributes: nil
          )
          try mergeDirectories(from: fileUrl, to: destinationFileUrl)
        } else {
          try fileManager.copyItem(at: fileUrl, to: destinationFileUrl)
        }
      }
    }
  }
}
