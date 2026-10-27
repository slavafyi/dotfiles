local home = assert(os.getenv 'HOME')
local shell = assert(os.getenv 'SHELL')

local function display_path(dir)
  local dev = home .. '/dev/'
  if dir:sub(1, #dev) == dev then return dir:sub(#dev + 1) end
  if dir:sub(1, #home + 1) == home .. '/' then return '~' .. dir:sub(#home + 1) end
  return dir
end

local function project_label(dir, git)
  local folder = dir:match '([^/]+)$' or '/'
  local name = folder
  if git then
    local origin = rex.exec({ git, '-C', dir, 'remote', 'get-url', 'origin' }, { timeout = 5 })
    if origin and origin.ok then
      local url = origin.stdout:gsub('%s+$', ''):gsub('/+$', '')
      name = (url:match '([^/:]+)$' or ''):gsub('%.git$', '')
      if name == '' then name = folder end
    end
  end

  local path = display_path(dir)
  if name == folder and dir ~= '/' then
    path = path:sub(1, #path - #folder)
    if path == '' then path = './' end
  end
  return name .. '@' .. path
end

local function open_project(dir, label)
  local list = assert(rex.call 'session.list')
  local session_id
  for _, session in ipairs(list.sessions or {}) do
    if session.label == label then
      assert(not session_id, 'Multiple sessions named ' .. label)
      session_id = session.session_id
    end
  end

  if not session_id then
    local created = assert(rex.call('session.create', {
      label = label,
      initial_windows = {
        {
          layout = rex.layout.block {
            flavor = 'com.superlogical.terminal.shell',
            options = { cwd = dir },
          },
        },
      },
    }))
    session_id = created.session_id
  end

  rex.client.queue('session.select', { session_id = session_id })
end

local listed, err = rex.exec({ shell, '-lic', 'command zoxide query --list' }, { timeout = 5 })
if not listed or not listed.ok then
  rex.log('warn', 'Project actions unavailable: ' .. (err or listed.stderr))
  return
end

local found_git = rex.exec({ shell, '-lic', 'command -v git' }, { timeout = 5 })
local git = found_git and found_git.ok and found_git.stdout:match '([^\r\n]+)'
local seen = {}
for path in listed.stdout:gmatch '[^\r\n]+' do
  local dir = path:gsub('/+$', '')
  if dir == '' then dir = '/' end
  if not seen[dir] then
    seen[dir] = true
    local label = project_label(dir, git)
    local id = dir:gsub('.', function(char)
      return ('%02x'):format(char:byte())
    end)
    rex.action {
      name = 'project_' .. id,
      title = 'Project: ' .. label,
      category = 'Projects',
      keywords = dir,
      run = function()
        open_project(dir, label)
      end,
    }
  end
end
