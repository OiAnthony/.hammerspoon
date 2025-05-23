-- 全局快捷键绑定
local globalKeybindings = {}

local hotkeyManager = require("utils.hotkey_manager")

-- 初始化全局快捷键
function globalKeybindings.init()
    -- 使用快捷键管理器初始化所有快捷键
    hotkeyManager.init()

    -- 验证快捷键是否可用
    hotkeyManager.validateHotkeys()
end

return globalKeybindings
