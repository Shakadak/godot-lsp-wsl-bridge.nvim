-- Client <== Server

local deepcopy = require("lsp.gdscript.table.addition").deepcopy

local transform = require("lsp.gdscript.transform")

local identity = transform.identity
local toUPath = transform.toUPath
local onFileUri = transform.onFileUri
local defaultTransform = transform.defaultTransform

local function publishDiagnostics(params)
  local new_params = deepcopy(params)
  new_params.uri = onFileUri(toUPath, params.uri)
  return new_params
end

local function changeWorkspace(params)
  -- log:write('changeWorkspace', params)
  local new_params = deepcopy(params)
  new_params.path = toUPath(params.path)
  return new_params
end

local notification_transform = {
  ["gdscript/capabilities"] = identity,
  ["gdscript_client/changeWorkspace"] = changeWorkspace,
  ["textDocument/publishDiagnostics"] = publishDiagnostics,
}
setmetatable(notification_transform, {__index = defaultTransform('notification_transform')})

return notification_transform
