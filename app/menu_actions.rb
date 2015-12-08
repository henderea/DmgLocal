module MenuActions
  module_function

  def setup
    MainMenu[:statusbar].items[:status_readonly][:state] = Persist.store.read_only? ? NSOnState : NSOffState
    MainMenu[:statusbar].subscribe(:status_readonly) { |_, _|
      Persist.store.read_only                              = MainMenu[:statusbar].items[:status_readonly][:state] == NSOffState
      MainMenu[:statusbar].items[:status_readonly][:state] = Persist.store.read_only? ? NSOnState : NSOffState
    }
  end
end