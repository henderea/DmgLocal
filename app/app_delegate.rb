# noinspection RubyUnusedLocalVariable
class AppDelegate
  def applicationDidFinishLaunching(notification)
    Util.setup_logging
    BITHockeyManager.sharedHockeyManager.configureWithIdentifier('e1b5fa7615f5468096f1655b8ec96d87', delegate: self)
    BITHockeyManager.sharedHockeyManager.crashManager.setAutoSubmitCrashReport(true)
    BITHockeyManager.sharedHockeyManager.startManager
    SUUpdater.sharedUpdater.setDelegate(self)
    Persist.store.load_prefs
    MainMenu.build!
    MenuActions.setup
    MainMenu[:statusbar].items[:status_version][:title] = "Current Version: #{Info.version}"
  end

  def application(sender, openFiles: filenames)
    Util.log.debug 'application:openFiles called'
    filenames.select { |fname| File.exist?(fname) && %w(.dmg .sparsebundle).include?(File.extname(fname)) }.each { |fname|
      fname = File.expand_path(fname)
      dir   = File.dirname(fname)
      Util.log.debug "Dir: #{dir}; fname: #{fname}"
      system("hdiutil attach '#{fname}' -mountroot '#{dir}'#{Persist.store.read_only? ? ' -readonly' : ''}")
    }
    true
  end

  def feedParametersForUpdater(updater, sendingSystemProfile: sendingProfile)
    BITSystemProfile.sharedSystemProfile.systemUsageData
  end

  def getLatestLogFileContent
    description        = ''
    sortedLogFileInfos = Util.file_logger.logFileManager.sortedLogFileInfos
    sortedLogFileInfos.reverse_each { |logFileInfo|
      logData = NSFileManager.defaultManager.contentsAtPath logFileInfo.filePath
      if logData.length > 0
        description = NSString.alloc.initWithBytes(logData.bytes, length: logData.length, encoding: NSUTF8StringEncoding)
        break
      end
    }
    description
  end

  def applicationLogForCrashManager(crashManager)
    description = self.getLatestLogFileContent
    if description.nil? || description.length <= 0
      nil
    else
      description
    end
  end
end
