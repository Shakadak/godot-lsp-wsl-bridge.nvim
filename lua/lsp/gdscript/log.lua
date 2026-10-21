--[[

local log_date_format = '%F %H:%M:%S'
local function format_func(level, ...)
  -- if log_levels[level] < current_log_level then
  --   return nil
  -- end

  -- local info = debug.getinfo(2, 'Sl')
  local header = string.format(
    '[%s][%s] %s',
    level,
    os.date(log_date_format),
    debug.traceback()
  )
  local parts = { header }
  local argc = select('#', ...)
  for i = 1, argc do
    local arg = select(i, ...)
    table.insert(parts, arg == nil and 'nil' or vim.inspect(arg))
    -- table.insert(parts, arg == nil and 'nil' or vim.inspect(arg, { newline = ' ', indent = '' }))
  end
  return table.concat(parts, '\t') .. '\n'
end

---]]

return {
    _log_path = '/tmp/nvimdebug.log',
    _this_is_a_log_table = true,
    write = function(self, ...)
        if not self._this_is_a_log_table then
            error('Please call `log:write` with a semicolon')
        end
        if not self._fh then
            self._fh = io.open(self._log_path, 'a')
        end
        local buf = {}
        for i = 1, select('#', ...) do
            local v = select(i, ...)
            table.insert(buf, vim.inspect(v))
        end
        self._fh:write(
            os.date('%Y:%m:%d %H.%M.%S')
            .. ' '
            .. debug.getinfo(2).source
            .. '\n'
            .. table.concat(buf, '\n')
            .. '\n\n'
        )
        self._fh:flush()
    end,
    script_path = function()
        return debug.getinfo(2, "S").source:sub(2)
    end,
}
