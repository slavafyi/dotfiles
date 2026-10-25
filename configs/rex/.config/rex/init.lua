require 'projects'

rex.bind('ctrl+space>c', 'client.tab.new')
rex.bind('ctrl+space>n', 'client.tab.next')
rex.bind('ctrl+space>p', 'client.tab.previous')

rex.bind('ctrl+space>shift+5', 'pane.split', { direction = 'right' })
rex.bind("ctrl+space>shift+'", 'pane.split', { direction = 'down' })
rex.bind('ctrl+space>k', 'pane.focus', { direction = 'up' })
rex.bind('ctrl+space>j', 'pane.focus', { direction = 'down' })
rex.bind('ctrl+space>h', 'pane.focus', { direction = 'left' })
rex.bind('ctrl+space>l', 'pane.focus', { direction = 'right' })
rex.bind('ctrl+space>z', 'pane.zoom')
