require 'projects'

rex.bind('cmd+ctrl+h', 'client.host.switch')

rex.bind('cmd+ctrl+r', 'session.rename')
rex.bind('cmd+ctrl+w', 'session.close')
rex.bind('cmd+ctrl+n', 'session.next')
rex.bind('cmd+ctrl+p', 'session.previous')
