require 'projects'

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

local command_center_label = 'Command Center'
local terminal = 'com.superlogical.terminal'

-- Config actions share this state and only switch at a Rex call.
local opening_huddle = false

local function is_huddle(proc)
  return proc and proc.name == 'huddle'
end

local function process_has_huddle(process)
  if is_huddle(process.foreground) or is_huddle(process.child) then return true end
  for _, proc in ipairs(process.ancestors or {}) do
    if is_huddle(proc) then return true end
  end
  return false
end

local function huddle_layout()
  return rex.layout.block {
    flavor = terminal .. '.shell',
    options = { command = { 'huddle' } },
  }
end

local function command_center_session()
  local list, err = rex.call 'session.list'
  if not list then error(err, 0) end

  local session_id
  for _, session in ipairs(list.sessions or {}) do
    if session.label == command_center_label then
      if session_id then error('Multiple sessions named ' .. command_center_label, 0) end
      session_id = session.session_id
    end
  end
  return session_id
end

local function huddle_window(session_id, view)
  for _, window in ipairs(view.windows or {}) do
    for _, layer in ipairs(window.layers or {}) do
      for _, block in ipairs(layer.blocks or {}) do
        if block.creator_name == terminal and block.block_id then
          local process, err = rex.block.call(terminal, 'process', {
            session_id = session_id,
            block_id = block.block_id,
          })
          if not process then error(err, 0) end
          if process_has_huddle(process) then return window.window_id end
        end
      end
    end
  end
end

local function open_huddle()
  local session_id = command_center_session()
  local window_id

  if session_id then
    local attached, err = rex.call('session.attach', { session_id = session_id })
    if not attached then error(err, 0) end
    window_id = huddle_window(session_id, attached.view)
    if not window_id then
      local created, create_err = rex.session.new_window {
        session_id = session_id,
        layout = huddle_layout(),
      }
      if not created then error(create_err, 0) end
      window_id = created.window_id
    end
  else
    local created, err = rex.call('session.create', {
      label = command_center_label,
      initial_windows = { { layout = huddle_layout() } },
    })
    if not created then error(err, 0) end
    session_id = created.session_id
    window_id = created.initial_windows[1].window_id
  end

  rex.client.queue('session.select', {
    session_id = session_id,
    window_id = window_id,
  })
end

rex.action {
  name = 'open_huddle',
  title = 'Open Huddle',
  run = function()
    if opening_huddle then return end

    opening_huddle = true
    local ok, err = pcall(open_huddle)
    opening_huddle = false
    if not ok then error(err, 0) end
  end,
}

rex.bind('cmd+ctrl+h', 'client.host.switch')
rex.bind('cmd+ctrl+g', 'open_lazygit')
rex.bind('cmd+ctrl+o', 'open_huddle')

rex.bind('cmd+ctrl+r', 'session.rename')
rex.bind('cmd+ctrl+w', 'session.close')
rex.bind('cmd+ctrl+n', 'session.next')
rex.bind('cmd+ctrl+p', 'session.previous')
