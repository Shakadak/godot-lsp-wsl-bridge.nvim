-- Client <== Server

local table_addition = require("lsp.gdscript.table.addition")
local mapKeys = table_addition.mapKeys

local transform = require("lsp.gdscript.transform")

local defaultTransform = transform.defaultTransform
local onParams = transform.onParams
local onKey = transform.onKey
local onFileUri = transform.onFileUri
local toUPath = transform.toUPath

local server_request_transform = {
  ["workspace/applyEdit"] = onParams(onKey("edit", onKey("changes", mapKeys(onFileUri(toUPath))))),
}
setmetatable(server_request_transform, {__index = defaultTransform('server_request_transform')})

return server_request_transform
