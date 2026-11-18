require 'huddle'
require 'lazygit'

require('projects').setup {
  roots = { '~/dev' },
  bookmarks = { '~/notes' },
}

rex.bind('cmd+ctrl+h', 'client.host.switch')
rex.bind('cmd+ctrl+g', 'open_lazygit')
rex.bind('cmd+ctrl+u', 'open_huddle')
rex.bind('cmd+ctrl+o', 'projects_open')

rex.bind('cmd+ctrl+r', 'session.rename')
rex.bind('cmd+ctrl+w', 'session.close')
rex.bind('cmd+ctrl+n', 'session.next')
rex.bind('cmd+ctrl+p', 'session.previous')
