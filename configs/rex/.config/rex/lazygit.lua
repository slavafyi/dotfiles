rex.action {
  name = 'open_lazygit',
  title = 'Open Lazygit',
  run = function()
    local process = assert(rex.block.call('com.superlogical.terminal', 'process', {}))
    local cwd = assert(
      process.foreground and process.foreground.cwd,
      'Cannot read the focused terminal directory'
    )

    assert(rex.session.new_layer {
      bounds = { 0, 0, 1, 1 },
      focus = true,
      layout = rex.layout.block {
        flavor = 'com.superlogical.terminal.shell',
        options = {
          command = { 'lazygit' },
          cwd = cwd,
        },
      },
    })
  end,
}
