local M = {}

local required_major = 22
local cached_version

local function get_major(version)
  return tonumber((version or ''):match 'v?(%d+)')
end

function M.node_version()
  if cached_version ~= nil then
    return cached_version
  end

  local node = vim.fn.exepath 'node'
  if node == '' then
    cached_version = false
    return nil
  end

  local result = vim.system({ node, '--version' }, { text = true }):wait()
  if result.code ~= 0 then
    cached_version = false
    return nil
  end

  cached_version = vim.trim(result.stdout or '')
  return cached_version
end

function M.has_supported_node()
  local version = M.node_version()
  local major = get_major(version)
  return major ~= nil and major >= required_major
end

function M.notify_if_unsupported()
  if M.has_supported_node() or vim.g.copilot_node_warning_shown then
    return M.has_supported_node()
  end

  vim.g.copilot_node_warning_shown = true

  local version = M.node_version()
  local detail = version and ('found ' .. version) or 'node was not found in PATH'

  vim.schedule(function()
    vim.notify(
      string.format('Copilot disabled: Node.js %d+ is required, but %s.', required_major, detail),
      vim.log.levels.WARN,
      { title = 'GitHub Copilot' }
    )
  end)

  return false
end

return M
