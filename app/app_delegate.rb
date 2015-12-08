class AppDelegate
  def applicationDidFinishLaunching(notification)
    Persist.store.load_prefs
    MainMenu.build!
    MenuActions.setup
    MainMenu[:statusbar].items[:status_version][:title] = "Current Version: #{Info.version}"
  end

  def application(sender, openFiles: filenames)
    filenames.select { |fname| File.exist?(fname) && File.extname(fname) == '.dmg' }.each { |fname|
      fname = File.expand_path(fname)
      dir   = File.dirname(fname)
      NSLog("Dir: #{dir}; fname: #{fname}")
      system("hdiutil attach '#{fname}' -mountroot '#{dir}'#{Persist.store.read_only? ? ' -readonly' : ''}")
    }
    true
  end
end
