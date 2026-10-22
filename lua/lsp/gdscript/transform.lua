local log = require('lsp.gdscript.log')

local map = require("lsp.gdscript.table.addition").map
local deepcopy = require("lsp.gdscript.table.addition").deepcopy

local wsl_path = require("lsp.gdscript.path")

local M = {}

function M.onFileUri(f, maybe_str)
  local function run(str)
    local prefix = "file://"
    local prefix_len = string.len(prefix)
    if string.sub(str, 1, prefix_len) == prefix then
      return vim.uri_from_fname(f(vim.uri_to_fname(str)))
    end
    return str
  end

  if maybe_str == nil then
    return run
  else
    return run(maybe_str)
  end
end

function M.toWPath(path)
  -- local wslpath_result = vim.trim(vim.system({'wslpath', '-w', path}, { text = true }):wait().stdout)
  -- local custom_result = wsl_path.wsl_to_win(path)
  -- if wslpath_result ~= custom_result then
  --   log:write(string.format("toWPath divergence: %s <=> %s", wslpath_result, custom_result))
  -- end
  -- return wslpath_result
  return wsl_path.wsl_to_win(path)
end

function M.toUPath(path)
  -- local wslpath_result = vim.trim(vim.system({'wslpath', '-u', path}, { text = true }):wait().stdout)
  -- local custom_result = wsl_path.win_to_wsl(path)
  -- if wslpath_result ~= custom_result then
  --   log:write(string.format("toUPath divergence: %s <=> %s", wslpath_result, custom_result))
  -- end
  -- return wslpath_result
  return wsl_path.win_to_wsl(path)
end

function M.onParams(f)
  return function (params)
    return f(deepcopy(params))
  end
end

function M.onKey(key, f)
  return function (params)
    params[key] = f(params[key])
    return params
  end
end

function M.dbg(method, f)
  return function (params)
    log:write("before", method, params)
    local new_params = f(params)
    log:write("after", method, new_params)
    return new_params
  end
end

function M.deep_apply(tbl)
  local merge_apply = function (_, prev_value, value)
    if type(value) == "function" then
      return value(prev_value)
    else
      return value
    end
  end

  return function (params)
    return vim.tbl_deep_extend(merge_apply, params, tbl)
  end
end

function M.textDocument_uri(f)
  return M.deep_apply({ textDocument = { uri = M.onFileUri(f) } })
  -- return M.onParams(M.onKey("textDocument", M.onKey("uri", M.onFileUri(f))))
end

function M.identity(params)
  return params
end

function M.defaultTransform(context)
  return function(_, method)
    return function (params)
      log:write(context, method, params)
      return params
    end
  end
end



function M.onResult(f)
  return function (error, result)
    if error ~= nil then
      log:write("onResult.error", error)
    end
    return error, f(result)
  end
end

function M.onResults(f)
  return function (error, results)
    if error ~= nil then
      log:write("onResults.error", error)
    end
    return error, map(f, results)
  end
end

function M.biIdentity(error, result)
  if error ~= nil then
    log:write("biIdentity.error", error)
  end
  return error, result
end

function M.dbg2(method, f)
  return function (error, result)
    local new_error, new_params = f(error, result)
    log:write(method, new_error, new_params)
    return new_error, new_params
  end
end

function M.defaultCallbackTransform(context)
  return function(_, method)
    return function (error, result)
      log:write(context, method, error, result)
      return error, result
    end
  end
end

return M
