-- Client <== Server

local Transform = require("lsp.gdscript.transform")

local identity = Transform.identity
local toUPath = Transform.toUPath
local onFileUri = Transform.onFileUri
local defaultTransform = Transform.defaultTransform

local publishDiagnostics = Transform.deep_apply({
  uri = onFileUri(toUPath)
})

local changeWorkspace = Transform.deep_apply({
  path = toUPath
})

local notification_transform = {
  ["gdscript/capabilities"] = identity,
  ["gdscript_client/changeWorkspace"] = changeWorkspace,
  ["textDocument/publishDiagnostics"] = publishDiagnostics,
}
setmetatable(notification_transform, {__index = defaultTransform('notification_transform')})

return notification_transform
