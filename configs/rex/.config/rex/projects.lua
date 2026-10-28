local home = assert(os.getenv 'HOME')
local shell = assert(os.getenv 'SHELL')

local function display_path(dir)
  local dev = home .. '/dev/'
  if dir:sub(1, #dev) == dev then return dir:sub(#dev + 1) end
  if dir:sub(1, #home + 1) == home .. '/' then return '~' .. dir:sub(#home + 1) end
  return dir
end

local function project_label(dir, origin)
  local folder_name = dir:match '([^/]+)$' or '/'
  local project_name = folder_name

  if origin ~= '' then
    local url = origin:gsub('%s+$', ''):gsub('/+$', '')
    project_name = (url:match '([^/:]+)$' or ''):gsub('%.git$', '')
    if project_name == '' then project_name = folder_name end
  end

  local path = display_path(dir)
  if project_name == folder_name and dir ~= '/' then
    path = path:sub(1, #path - #folder_name)
    if path == '' then path = './' end
  end

  return project_name .. '@' .. path
end

local function is_project_directory(dir)
  local dev_dir = home .. '/dev'
  local dev_prefix = dev_dir .. '/'

  return dir == dev_dir or dir:sub(1, #dev_prefix) == dev_prefix or dir == home .. '/notes'
end

local function read_projects()
  local cache_home = os.getenv 'XDG_CACHE_HOME'
  if not cache_home or cache_home == '' then cache_home = home .. '/.cache' end

  local cache = io.open(cache_home .. '/rex/projects', 'rb')
  if not cache then
    rex.log('warn', 'Project cache unavailable. Run Projects: Refresh.')
    return
  end

  local contents = cache:read '*a'
  cache:close()

  local projects = {}
  local offset = 1

  while offset <= #contents do
    local dir_end = contents:find('\0', offset, true)
    local origin_end = dir_end and contents:find('\0', dir_end + 1, true)

    if not dir_end or not origin_end then
      rex.log('warn', 'Invalid project cache. Run Projects: Refresh.')
      return
    end

    local dir = contents:sub(offset, dir_end - 1)
    if is_project_directory(dir) then
      projects[#projects + 1] = {
        dir = dir,
        origin = contents:sub(dir_end + 1, origin_end - 1),
      }
    end

    offset = origin_end + 1
  end

  return projects
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

local function refresh_projects()
  local result, err = rex.exec({
    shell,
    '-lic',
    'exec "$HOME/.local/bin/rex-projects-refresh"',
  }, { timeout = 20 })

  if not result then error(err, 0) end
  if not result.ok then error('Project refresh failed: ' .. result.stderr, 0) end

  rex.client.queue 'client.config.reload'
end

rex.action {
  name = 'projects_refresh',
  title = 'Projects: Refresh',
  category = 'Projects',
  run = refresh_projects,
}

local projects = read_projects()
if not projects then return end

local seen_dirs = {}
for _, project in ipairs(projects) do
  local dir = project.dir
  if not seen_dirs[dir] then
    seen_dirs[dir] = true

    local label = project_label(dir, project.origin)
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
