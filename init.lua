-- Hammerspoon 主配置文件
-- 作者: Assistant
-- 功能: 自动切换输入法和全局快捷键管理

-- 加载模块
local autoInputMethod = require("modules.auto_input_method")
local globalKeybindings = require("keybindings.global")
local alertManager = require("utils.alert_manager")
local hotkeyManager = require("utils.hotkey_manager")

-- 配置重新加载提示
function reloadConfig(files)
    doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

-- 监听配置文件变化
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

-- 初始化所有模块
function init()
    -- 显示启动消息
    alertManager.info("🔨 Hammerspoon 配置加载中...", 1.5)

    -- 初始化自动输入法切换
    autoInputMethod.init()

    -- 初始化全局快捷键
    globalKeybindings.init()

    -- 显示完成消息
    alertManager.success("Hammerspoon 配置加载完成!", 2)

    -- 自动打印启动信息（使用 API 获取快捷键信息）
    print("=== Hammerspoon 配置已加载 ===")
    print("功能:")
    print("  - 自动输入法切换（IDE应用自动切换到英文）")
    print("  - 美化的提醒系统（默认关闭输入法切换提醒）")
    print("  - 统一的快捷键管理系统")
    print()

    -- 使用快捷键管理器自动生成快捷键信息
    hotkeyManager.printStartupInfo()
end

-- 启动配置
init()
