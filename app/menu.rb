class MainMenu
  extend EverydayMenu::MenuBuilder

  menuItem :hide_others, 'Hide Others', preset: :hide_others
  menuItem :show_all, 'Show All', preset: :show_all
  menuItem :close, 'Close', preset: :close
  menuItem :quit, 'Quit', preset: :quit

  menuItem :services_item, 'Services', preset: :services

  menuItem :status_readonly, 'Mount as read-only', state: NSOffState
  menuItem :status_version, 'Current Version: 0.0'
  menuItem :status_quit, 'Quit', preset: :quit

  mainMenu(:app, 'DmgLocal') {
    hide_others
    show_all
    ___
    services_item
    ___
    close
    ___
    quit
  }

  statusbarMenu(:statusbar, '', status_item_icon: NSImage.imageNamed('Status')) {
    status_readonly
    ___
    status_version
    ___
    status_quit
  }
end