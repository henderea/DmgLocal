module MenuActions
  module_function

  def persisted_checkbox_item(item_label, persist_label)
    item_label                                     = item_label.to_sym
    MainMenu[:statusbar].items[item_label][:state] = Persist.store["#{persist_label}?"] ? NSOnState : NSOffState
    MainMenu[:statusbar].subscribe(item_label) { |_, _|
      Persist.store[persist_label]                   = MainMenu[:statusbar].items[item_label][:state] == NSOffState
      MainMenu[:statusbar].items[item_label][:state] = Persist.store["#{persist_label}?"] ? NSOnState : NSOffState
    }
  end

  def setup
    # MainMenu[:statusbar].items[:status_readonly][:state] = Persist.store.read_only? ? NSOnState : NSOffState
    # MainMenu[:statusbar].subscribe(:status_readonly) { |_, _|
    #   Persist.store.read_only                              = MainMenu[:statusbar].items[:status_readonly][:state] == NSOffState
    #   MainMenu[:statusbar].items[:status_readonly][:state] = Persist.store.read_only? ? NSOnState : NSOffState
    # }
    persisted_checkbox_item :status_readonly, :read_only
    persisted_checkbox_item :status_passthrough, :passthrough
    MainMenu[:statusbar].subscribe(:status_update) { |_, sender| SUUpdater.sharedUpdater.checkForUpdates(sender) }
  end
end