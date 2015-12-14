module MenuActions
  module_function

  def persisted_checkbox_item(item_label, persist_label)
    item_label                                     = item_label.to_sym
    MainMenu[:statusbar].items[item_label][:state] = Persist.store["#{persist_label}?"] ? NSOnState : NSOffState
    MainMenu[:statusbar].subscribe(item_label, item_label) { |_, _|
      Persist.store[persist_label]                   = MainMenu[:statusbar].items[item_label][:state] == NSOffState
      MainMenu[:statusbar].items[item_label][:state] = Persist.store["#{persist_label}?"] ? NSOnState : NSOffState
    }
  end

  def setup
    persisted_checkbox_item :status_readonly, :read_only
    persisted_checkbox_item :status_passthrough, :passthrough
    MainMenu[:statusbar].items[:status_readonly][:commands][:status_readonly].canExecuteBlock { |_| !Persist.store.passthrough? }
    Persist.store.force_listeners :passthrough
    MainMenu[:statusbar].subscribe(:status_update) { |_, sender| SUUpdater.sharedUpdater.checkForUpdates(sender) }
  end
end