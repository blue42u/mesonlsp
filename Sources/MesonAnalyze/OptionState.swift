public class OptionState {
  public var opts: [String: MesonOption] = [:]
  init(options: [MesonOption]) {
    self.append(option: StringOption("prefix", nil))
    self.append(option: StringOption("bindir", nil))
    self.append(option: StringOption("datadir", nil))
    self.append(option: StringOption("includedir", nil))
    self.append(option: StringOption("infodir", nil))
    self.append(option: StringOption("libdir", nil))
    self.append(option: StringOption("licensedir", nil))
    self.append(option: StringOption("libexecdir", nil))
    self.append(option: StringOption("localedir", nil))
    self.append(option: StringOption("localstatedir", nil))
    self.append(option: StringOption("mandir", nil))
    self.append(option: StringOption("sbindir", nil))
    self.append(option: StringOption("sharedstatedir", nil))
    self.append(option: StringOption("sysconfdir", nil))
    self.append(option: FeatureOption("auto_features", nil))
    self.append(option: ComboOption("backend", nil))
    self.append(option: ComboOption("buildtype", nil))
    self.append(option: BoolOption("debug", nil))
    self.append(option: ComboOption("default_library", nil))
    self.append(option: BoolOption("errorlogs", nil))
    self.append(option: IntOption("install_umask", nil))
    self.append(option: ComboOption("layout", nil))
    self.append(option: ComboOption("optimization", nil))
    self.append(option: ArrayOption("pkg_config_path", nil))
    self.append(option: BoolOption("prefer_static", nil))
    self.append(option: ArrayOption("cmake_prefix_path", nil))
    self.append(option: BoolOption("stdsplit", nil))
    self.append(option: BoolOption("strip", nil))
    self.append(option: ComboOption("unity", nil))
    self.append(option: IntOption("unity_size", nil))
    self.append(option: ComboOption("warning_level", nil))
    self.append(option: BoolOption("werror", nil))
    self.append(option: ComboOption("wrap_mode", nil))
    self.append(option: ArrayOption("force_fallback_for", nil))
    self.append(option: BoolOption("b_asneeded", nil))
    self.append(option: BoolOption("b_bitcode", nil))
    self.append(option: ComboOption("b_colorout", nil))
    self.append(option: BoolOption("b_coverage", nil))
    self.append(option: BoolOption("b_lundef", nil))
    self.append(option: BoolOption("b_lto", nil))
    self.append(option: IntOption("b_lto_threads", nil))
    self.append(option: ComboOption("b_lto_mode", nil))
    self.append(option: BoolOption("b_thinlto_cache", nil))
    self.append(option: StringOption("b_thinlto_cache_dir", nil))
    self.append(option: BoolOption("b_ndebug", nil))
    self.append(option: BoolOption("b_pch", nil))
    self.append(option: BoolOption("b_pgo", nil))
    self.append(option: ComboOption("b_sanitize", nil))
    self.append(option: BoolOption("b_staticpic", nil))
    self.append(option: BoolOption("b_pie", nil))
    self.append(option: ComboOption("b_vscrt", nil))
    self.append(option: StringOption("c_args", nil))
    self.append(option: StringOption("c_link_args", nil))
    self.append(option: ComboOption("c_std", nil))
    self.append(option: StringOption("c_winlibs", nil))
    self.append(option: IntOption("c_thread_count", nil))
    self.append(option: StringOption("cpp_args", nil))
    self.append(option: StringOption("cpp_link_args", nil))
    self.append(option: ComboOption("cpp_std", nil))
    self.append(option: BoolOption("cpp_debugstl", nil))
    self.append(option: ComboOption("cpp_eh", nil))
    self.append(option: BoolOption("cpp_rtti", nil))
    self.append(option: IntOption("cpp_thread_count", nil))
    self.append(option: StringOption("cpp_winlibs", nil))
    self.append(option: ComboOption("fortran_std", nil))
    self.append(option: StringOption("cuda_ccbindir", nil))
    for o in options { self.append(option: o) }
  }

  func append(option: MesonOption) { self.opts[option.name] = option }
}
