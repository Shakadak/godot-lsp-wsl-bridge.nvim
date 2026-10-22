local notification_transform = require("lsp.gdscript.transform.notification")
local server_request_transform = require("lsp.gdscript.transform.server_request")

local request_transform = require("lsp.gdscript.transform.request")
local request_callback_transform = require("lsp.gdscript.transform.request_callback")
local notify_transform = require("lsp.gdscript.transform.notify")

-- local log = require('lsp.gdscript.log')

local wrapper = function(dispatchers, config)
  local port = os.getenv 'GDScript_Port' or config.GDScript_Port or '6005'
  local cmd = vim.lsp.rpc.connect('127.0.0.1', tonumber(port))
  -- log:write("dispatchers", dispatchers)
  -- log:write("config", config)
  -- log:write("config.GDScript_Port", config.GDScript_Port)
  -- log:write("port: " .. port)

  local notification = function(method, params)
    local new_params = notification_transform[method](params)
    -- log:write('notification', method, new_params)
    return dispatchers.notification(method, new_params)
  end

  local server_request = function(method, params)
    local new_params = server_request_transform[method](params)
    -- log:write('server_request', method, new_params)
    return dispatchers.server_request(method, new_params)
  end

  local new_dispatchers = vim.tbl_deep_extend('force', dispatchers, {
    notification = notification,
    server_request = server_request,
  })

  -- vim.print(new_dispatchers)

  -- log:write("new_dispatchers", new_dispatchers)
  -- log2.debug('wrapper(dispatchers)', dispatchers)
  local public_client = cmd(new_dispatchers)
  -- log:write("public_client", public_client)

  local function request(method, params, callback, notify_reply_callback)
    -- TODO: consider wrapping `callback` and `notify_reply_callback`

    local new_params = request_transform[method](params)
    -- if method ~= "initialize" then
      -- log:write('request', method, new_params, callback, notify_reply_callback)
    -- end

    local function new_callback(error, result)
      local new_error, new_result = request_callback_transform[method](error, result)
      return callback(new_error, new_result)
    end

    return public_client.request(method, new_params, new_callback, notify_reply_callback)
  end

  local function notify(method, params)
    local new_params = notify_transform[method](params)
    -- log:write('notify', method, new_params)
    return public_client.notify(method, new_params)
  end

  local new_public_client = vim.tbl_deep_extend('force', public_client, {
    notify = notify,
    request = request,
  })

  return new_public_client
end

vim.lsp.config("gdscript", {
  GDScript_Port = 6005,
  cmd = wrapper,
  filetypes = { "gdscript" },
  root_markers = { "project.godot", ".git" },
})
