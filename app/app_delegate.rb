class AppDelegate
  def applicationDidFinishLaunching(notification)
  end

  def application(sender, openFiles: filenames)
    NSLog('Starting DmgLocal')
    filenames.select { |fname| File.exist?(fname) && File.extname(fname) == '.dmg' }.each { |fname|
      fname = File.expand_path(fname)
      dir = File.dirname(fname)
      NSLog("Dir: #{dir}; fname: #{fname}")
      system("hdiutil attach '#{fname}' -mountroot '#{dir}'")
    }
    Thread.start {
      sleep(1)
      NSApp.terminate(nil)
    }
    true
  end
end
