local home = assert(os.getenv 'HOME')
local worktrees_dir = home .. '/.rex/worktrees'
local terminal = 'com.superlogical.terminal'
local state_home = os.getenv 'XDG_STATE_HOME'
if not state_home or state_home == '' then state_home = home .. '/.local/state' end
local state_dir = state_home .. '/rex'
local state_path = state_dir .. '/project-sessions.json'
local locations

local function normalize_dir(path)
  local dir = path:gsub('/+$', '')
  return dir == '' and '/' or dir
end

local function configured_dir(path)
  if path == '~' then return home end
  if path:sub(1, 2) == '~/' then path = home .. path:sub(2) end
  assert(
    path:sub(1, 1) == '/',
    'Project roots and bookmarks must be absolute paths or start with ~/'
  )
  return normalize_dir(path)
end

local function setup(options)
  if options.roots == nil and options.bookmarks == nil then
    locations = nil
    return
  end

  local roots, bookmarks = {}, {}
  for _, path in ipairs(options.roots or {}) do
    roots[#roots + 1] = configured_dir(path)
  end
  for _, path in ipairs(options.bookmarks or {}) do
    bookmarks[configured_dir(path)] = true
  end
  locations = { roots = roots, bookmarks = bookmarks }
end

local function is_within(dir, root)
  return root == '/' or dir == root or dir:sub(1, #root + 1) == root .. '/'
end

local function is_project(dir)
  if is_within(dir, worktrees_dir) then return false end
  if not locations or locations.bookmarks[dir] then return true end
  for _, root in ipairs(locations.roots) do
    if is_within(dir, root) then return true end
  end
  return false
end

local function basename(path)
  return path:match '([^/]+)$' or '/'
end

local function display_path(dir)
  if dir:sub(1, #home + 1) == home .. '/' then return '~' .. dir:sub(#home + 1) end
  return dir
end

local function pick(title, placeholder, items)
  local id, reason, detail = rex.ui.pick { title = title, placeholder = placeholder, items = items }
  if not id and reason ~= 'cancelled' then error(detail or reason, 0) end
  return id
end

local function pick_project()
  local options = { timeout = 5 }
  local result, err = rex.exec({ 'zoxide', 'query', '--list' }, options)
  local shell = os.getenv 'SHELL'
  if not result and shell then
    result, err = rex.exec({ shell, '-lic', 'exec zoxide query --list' }, options)
  end
  if not result then error(err, 0) end
  if not result.ok then error('Could not list zoxide directories: ' .. result.stderr, 0) end

  local items, seen = {}, {}
  for path in result.stdout:gmatch '[^\n]+' do
    local dir = normalize_dir(path)
    if not seen[dir] and is_project(dir) then
      seen[dir] = true
      items[#items + 1] =
        { id = dir, title = basename(dir), subtitle = display_path(dir), icon = 'folder' }
      if #items == 2000 then break end
    end
  end
  return pick('Open Project', 'Filter projects', items)
end

local function project_name(dir)
  local result = rex.exec({ 'git', '-C', dir, 'remote', 'get-url', 'origin' }, { timeout = 5 })
  if result and result.ok then
    local origin = result.stdout:gsub('%s+$', ''):gsub('/+$', '')
    local name = (origin:match '([^/:]+)$' or ''):gsub('%.git$', '')
    if name ~= '' then return name end
  end
  return basename(dir)
end

local function read_sessions()
  local file, err, code = io.open(state_path, 'rb')
  if not file then
    if code == 2 or (err and err:match 'no such file or directory$') then return {} end
    error(err, 0)
  end
  local contents = assert(file:read '*a')
  assert(file:close())
  local saved = rex.json.decode(contents)
  assert(type(saved) == 'table', 'Invalid project session file: ' .. state_path)
  return saved
end

local function save_session(dir, id)
  local saved = read_sessions()
  saved[dir] = id
  local contents = assert(rex.json.encode(saved))
  local temp_path = state_path .. '.' .. id:match '[^:]+$'
  local file = assert(io.open(temp_path, 'wb'))
  local wrote, write_error = file:write(contents, '\n')
  local closed, close_error = file:close()
  local renamed, rename_error
  if wrote and closed then
    renamed, rename_error = os.rename(temp_path, state_path)
  end
  if not renamed then
    os.remove(temp_path)
    error(write_error or close_error or rename_error, 0)
  end
  return id
end

local function valid_label(label)
  return label ~= '' and #label <= 128 and not label:find '%c'
end

local function find_session(dir, label)
  local saved_id = read_sessions()[dir]
  local sessions = assert(rex.call 'session.list').sessions or {}
  local occupied = false
  for _, session in ipairs(sessions) do
    if session.session_id == saved_id then return session end
    if session.label == label then occupied = true end
  end
  return nil, occupied
end

local function list_worktrees(dir)
  local command = { 'git', '-C', dir, 'worktree', 'list', '--porcelain', '-z' }
  local result = rex.exec(command, { timeout = 5 })
  local worktrees = {}
  if not result or not result.ok then return worktrees end

  for entry in result.stdout:gmatch '(.-)%z%z' do
    local record = entry .. '\0'
    local path = record:match '^worktree (.-)%z'
    if path then
      worktrees[#worktrees + 1] = {
        path = path,
        branch = record:match '%zbranch refs/heads/(.-)%z',
        available = not record:find '%zprunable' and not record:find '%zbare',
      }
    end
  end
  return worktrees
end

local function create_worktree(dir, main_checkout)
  local value, branch
  while true do
    local answer, reason, detail = rex.ui.input {
      title = 'New worktree',
      placeholder = 'feature/autopilot',
      value = value,
      confirm = value and 'Invalid branch name' or 'Create worktree',
    }
    if not answer then
      if reason == 'cancelled' then return end
      error(detail or reason, 0)
    end
    value = answer

    branch = answer:match '^%s*(.-)%s*$'
    if branch ~= '' and branch:sub(1, 1) ~= '-' then
      local check = { 'git', '-C', dir, 'check-ref-format', 'refs/heads/' .. branch }
      local valid, err = rex.exec(check, { timeout = 5 })
      if not valid then error(err, 0) end
      if valid.ok then break end
    end
  end

  for _, worktree in ipairs(list_worktrees(dir)) do
    if worktree.available and worktree.branch == branch then return worktree.path end
  end

  local session = find_session(dir)
  if not session and dir ~= main_checkout then session = find_session(main_checkout) end
  local name = session and session.label or project_name(dir)
  local folder = name:gsub('[/%c]', '-')
  if folder == '' or folder == '.' or folder == '..' then folder = basename(main_checkout) end
  local path = worktrees_dir .. '/' .. folder .. '/' .. branch
  local lookup = { 'git', '-C', dir, 'show-ref', '--verify', '--quiet', 'refs/heads/' .. branch }
  local existing, lookup_error = rex.exec(lookup, { timeout = 5 })
  if not existing then error(lookup_error, 0) end
  if not existing.ok and (existing.code ~= 1 or existing.timed_out) then
    error('Could not check local branch: ' .. existing.stderr, 0)
  end
  local command = existing.ok and { 'git', '-C', dir, 'worktree', 'add', '--', path, branch }
    or { 'git', '-C', dir, 'worktree', 'add', '-b', branch, '--', path, 'HEAD' }
  local result, add_error = rex.exec(command, { timeout = 20 })
  if not result then error(add_error, 0) end
  if not result.ok then error('Could not create worktree: ' .. result.stderr, 0) end
  return path
end

local function pick_checkout(dir)
  local worktrees = list_worktrees(dir)
  if #worktrees == 0 then return dir end

  local items = {}
  for _, worktree in ipairs(worktrees) do
    if worktree.available then
      items[#items + 1] = {
        id = worktree.path,
        title = worktree.branch or basename(worktree.path),
        subtitle = display_path(worktree.path),
        icon = 'branch',
      }
      if #items == 1999 then break end
    end
  end
  items[#items + 1] = { id = 'new-worktree', title = 'New worktree…', icon = 'plus' }

  local selected = pick(basename(dir), 'Choose a worktree', items)
  if selected == 'new-worktree' then return create_worktree(dir, worktrees[1].path) end
  return selected
end

local function unlinked_sessions()
  local linked = {}
  for _, id in pairs(read_sessions()) do
    linked[id] = true
  end

  local sessions = {}
  for _, session in ipairs(assert(rex.call 'session.list').sessions or {}) do
    if session.label ~= 'Command Center' and not linked[session.session_id] then
      sessions[#sessions + 1] = session
    end
  end
  return sessions
end

local function session_has_checkout(session_id, host_id, dir)
  local result = rex.call('session.list_blocks', { session_id = session_id })
  for _, block in ipairs(result and result.blocks or {}) do
    if
      block.placement == 'placed'
      and block.creator_name == terminal
      and block.host_id == host_id
    then
      local process = rex.call(terminal .. '.process', {
        session_id = session_id,
        block_id = block.block_id,
      })
      if process and type(process.foreground) == 'table' and process.foreground.cwd == dir then
        return true
      end
    end
  end
  return false
end

local function choose_session(dir)
  local sessions = unlinked_sessions()
  if #sessions == 0 then return 'new-session' end

  local status = rex.call 'server.status'
  local items, matches = {}, {}
  for _, session in ipairs(sessions) do
    local id = session.session_id
    local item = { id = id, title = session.label, detail = id:sub(-8), icon = 'terminal' }
    if #items < 2000 then items[#items + 1] = item end
    if status and status.host_id and session_has_checkout(id, status.host_id, dir) then
      if #matches < 2000 then matches[#matches + 1] = item end
    end
  end

  if #matches == 1 then return matches[1].id end
  local candidates = matches
  if #matches == 0 then
    local choice = pick('Session options', nil, {
      { id = 'new-session', title = 'Create session', icon = 'plus' },
      { id = 'link-session', title = 'Link existing session', icon = 'link' },
    })
    if choice ~= 'link-session' then return choice end
    candidates = items
  end
  return pick('Link existing session', 'Search sessions', candidates)
end

local function open_checkout(dir)
  local session = find_session(dir)
  if session then return session.session_id end

  local result, err = rex.exec({ 'mkdir', '-p', state_dir }, { timeout = 5 })
  if not result then error(err, 0) end
  if not result.ok then error('Could not create Rex state directory: ' .. result.stderr, 0) end

  local choice = choose_session(dir)
  if not choice then return end
  session = find_session(dir)
  if session then return session.session_id end
  if choice ~= 'new-session' then
    for _, candidate in ipairs(unlinked_sessions()) do
      if candidate.session_id == choice then return save_session(dir, choice) end
    end
    error('The selected session is no longer available to link.', 0)
  end

  local label = project_name(dir):match '^%s*(.-)%s*$'
  local parent = dir:match '^(.*)/[^/]+$' or ''
  local suggestion = label .. '-' .. basename(parent)
  local submitted
  while true do
    local existing, occupied = find_session(dir, label)
    if existing then return existing.session_id end
    if not occupied and valid_label(label) then break end

    local confirm = 'Create session'
    if submitted then
      confirm = occupied and 'Name taken' or 'Invalid name'
      if label == '' then confirm = 'Enter a name' end
    end
    local answer, reason, detail = rex.ui.input {
      title = 'New session',
      placeholder = 'warp-drive',
      value = submitted or (valid_label(suggestion) and suggestion or ''),
      confirm = confirm,
    }
    if not answer then
      if reason == 'cancelled' then return end
      error(detail or reason, 0)
    end
    submitted = answer
    label = answer:match '^%s*(.-)%s*$'
  end

  local layout = rex.layout.block { flavor = terminal .. '.shell', options = { cwd = dir } }
  local created = assert(rex.call('session.create', {
    label = label,
    initial_windows = { { layout = layout } },
  }))
  return save_session(dir, created.session_id)
end

rex.action {
  name = 'projects_open',
  title = 'Open Project',
  run = function()
    local dir = pick_project()
    local checkout = dir and pick_checkout(dir)
    local session_id = checkout and open_checkout(checkout)
    if session_id then rex.client.queue('session.select', { session_id = session_id }) end
  end,
}

return { setup = setup }
