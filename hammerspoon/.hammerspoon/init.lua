require("windows")

-- 机器专属应用快捷键（由 custom submodule 提供）
local ok, err = pcall(require, "switch-app")
if not ok then
  hs.logger.new("init"):w("switch-app not found, skipping: " .. tostring(err))
end
