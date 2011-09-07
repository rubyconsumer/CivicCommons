def bundler_10_installer(version)
  opts = [
    "--deployment",
    "--path #{c.shared_path}/bundled_gems",
    "--binstubs #{c.binstubs_path}",
    "--without development test cool_toys"
  ]
  BundleInstaller.new(version, opts.join(" "))
end
