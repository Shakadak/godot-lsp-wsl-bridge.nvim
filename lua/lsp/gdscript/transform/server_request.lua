-- Client <== Server

local table_addition = require("lsp.gdscript.table.addition")
local mapKeys = table_addition.mapKeys

local Transform = require("lsp.gdscript.transform")

local defaultTransform = Transform.defaultTransform
local onFileUri = Transform.onFileUri
local toUPath = Transform.toUPath

local server_request_transform = {
  ["workspace/applyEdit"] = Transform.deep_apply({ edit = { changes = mapKeys(onFileUri(toUPath)) } }),
}
setmetatable(server_request_transform, {__index = defaultTransform('server_request_transform')})

return server_request_transform
