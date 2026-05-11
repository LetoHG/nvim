local M = {}

local queue_tail_id = nil

local function is_active(task)
  return task and not task:is_disposed() and (task:is_pending() or task:is_running())
end

local function clear_tail(task)
  if queue_tail_id == task.id then
    queue_tail_id = nil
  end
end

local function get_queue_tail()
  local task_list = require 'overseer.task_list'

  if queue_tail_id then
    local queued_task = task_list.get(queue_tail_id)
    if is_active(queued_task) then
      return queued_task
    end
    queue_tail_id = nil
  end

  local ok, cmake_overseer = pcall(require, 'cmake-tools.overseer')
  if ok and is_active(cmake_overseer.job) then
    return cmake_overseer.job
  end
end

local function get_targets()
  local cmake = require 'cmake-tools'
  local result = cmake.get_build_targets()
  if result and result:is_ok() then
    return result.data.targets, result.data.display_targets
  end

  vim.notify(result and result.message or 'Unable to query CMake build targets', vim.log.levels.ERROR, {
    title = 'CMake Queue',
  })
end

local function make_build_task(target, parent_task)
  local cmake = require 'cmake-tools'
  local const = require 'cmake-tools.const'
  local overseer = require 'overseer'
  local config = cmake.get_config()
  local args

  if config.base_settings.use_preset and cmake.get_build_preset() then
    args = { '--build', '--preset', cmake.get_build_preset() }
  else
    if not config:has_build_directory() then
      vim.notify('Run :CMakeGenerate before queueing builds', vim.log.levels.ERROR, {
        title = 'CMake Queue',
      })
      return
    end
    args = { '--build', config:build_directory_path() }
  end

  vim.list_extend(args, { '--target', target })

  if cmake.get_build_type() then
    vim.list_extend(args, { '--config', cmake.get_build_type() })
  end

  vim.list_extend(args, cmake.get_build_options())

  local task = overseer.new_task {
    cmd = const.cmake_command,
    args = args,
    cwd = config.cwd,
    env = cmake.get_build_environment(),
    name = 'CMake Build ' .. target,
    components = { 'default' },
    parent_id = parent_task and parent_task.id or nil,
  }

  task:subscribe('on_complete', clear_tail)
  task:subscribe('on_dispose', clear_tail)

  if parent_task then
    parent_task:subscribe('on_complete', function(_, status)
      if status == 'SUCCESS' then
        task:start()
      else
        vim.notify('Skipped queued build for ' .. target .. ' because the previous build failed', vim.log.levels.WARN, {
          title = 'CMake Queue',
        })
        task:dispose(true)
      end
      return true
    end)
  else
    task:start()
  end

  queue_tail_id = task.id
  require('overseer').open { enter = false, direction = 'right' }
  return task
end

function M.queue_target(target)
  if not target or target == '' then
    return
  end

  local parent_task = get_queue_tail()
  return make_build_task(target, parent_task)
end

function M.queue_targets(targets)
  for _, target in ipairs(targets) do
    M.queue_target(target)
  end
end

function M.select_and_queue_target()
  local targets, display_targets = get_targets()
  if not targets then
    return
  end

  vim.ui.select(display_targets, { prompt = 'Queue CMake build target' }, function(_, idx)
    if idx then
      M.queue_target(targets[idx])
    end
  end)
end

function M.complete_targets()
  local targets = select(1, get_targets())
  return targets or {}
end

return M
