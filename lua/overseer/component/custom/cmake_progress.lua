return {
  desc = 'Track CMake/Ninja build progress for Overseer tasks',
  editable = false,
  serializable = false,
  constructor = function()
    local pending = ''

    local function get_base_name(task)
      local base_name = task.metadata.cmake_progress_base_name
      if base_name == nil then
        base_name = task.name
        task.metadata.cmake_progress_base_name = base_name
      end
      return base_name
    end

    local function set_task_name(task, prefix)
      local base_name = get_base_name(task)
      local next_name = prefix and (prefix .. ' ' .. base_name) or base_name
      if task.name == next_name then
        return
      end
      task.name = next_name
      require('overseer.task_list').touch(task)
    end

    local function clear_progress(task)
      pending = ''
      task.metadata.cmake_progress = nil
      task.metadata.cmake_progress_ratio = nil
      set_task_name(task, nil)
    end

    local function update_progress(task, percent)
      if task.metadata.cmake_progress == percent then
        return
      end

      task.metadata.cmake_progress = percent
      task.metadata.cmake_progress_ratio = nil
      set_task_name(task, string.format('[%d%%]', percent))
    end

    local function update_progress_ratio(task, current, total)
      if total <= 0 then
        return
      end

      local percent = math.floor((current / total) * 100 + 0.5)
      local ratio = string.format('%d/%d', current, total)
      if task.metadata.cmake_progress == percent and task.metadata.cmake_progress_ratio == ratio then
        return
      end

      task.metadata.cmake_progress = percent
      task.metadata.cmake_progress_ratio = ratio
      set_task_name(task, string.format('[%d%% %s]', percent, ratio))
    end

    local function try_extract_progress(task, text)
      local percent = text:match '%[%s*(%d+)%%%]'
      if percent then
        update_progress(task, tonumber(percent))
        return
      end

      local current, total = text:match '%[(%d+)%/(%d+)%]'
      if current and total then
        update_progress_ratio(task, tonumber(current), tonumber(total))
        return
      end
    end

    local function handle_text(task, text)
      if text == nil or text == '' then
        return
      end

      text = text:gsub('\r', '\n')
      local combined = pending .. text
      local start = 1

      while true do
        local newline = combined:find('\n', start, true)
        if not newline then
          pending = combined:sub(start)
          break
        end

        try_extract_progress(task, combined:sub(start, newline - 1))
        start = newline + 1
      end
    end

    return {
      on_start = function(_, task)
        clear_progress(task)
      end,
      on_reset = function(_, task)
        clear_progress(task)
      end,
      on_output = function(_, task, data)
        if type(data) == 'string' then
          handle_text(task, data)
          return
        end

        for _, chunk in pairs(data) do
          if type(chunk) == 'string' then
            handle_text(task, chunk)
          elseif type(chunk) == 'table' then
            for _, nested_chunk in ipairs(chunk) do
              if type(nested_chunk) == 'string' then
                handle_text(task, nested_chunk)
              end
            end
          end
        end
      end,
      on_output_lines = function(_, task, lines)
        for _, line in ipairs(lines) do
          try_extract_progress(task, line)
        end
      end,
      on_complete = function(_, task, status)
        if status == 'SUCCESS' then
          update_progress(task, 100)
        else
          set_task_name(task, nil)
        end
      end,
    }
  end,
}
