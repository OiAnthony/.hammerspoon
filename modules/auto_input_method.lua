-- 自动切换输入法模块
local autoInputMethod = {}

local constants = require("config.constants")
local inputMethodUtils = require("utils.input_method")
local alertManager = require("utils.alert_manager")

-- 应用切换监听器
local appWatcher = nil

-- 初始化自动输入法切换
function autoInputMethod.init()
    -- 创建应用监听器
    appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
        if eventType == hs.application.watcher.activated then
            autoInputMethod.handleAppActivated(appName)
        end
    end)

    -- 启动监听器
    appWatcher:start()

    alertManager.startup("自动输入法切换已启用")
end

-- 处理应用激活事件
function autoInputMethod.handleAppActivated(appName)
    if not appName then return end

    -- 获取应该使用的输入法
    local targetInputMethod = inputMethodUtils.getInputMethodForApp(appName, constants)

    -- 切换输入法
    inputMethodUtils.switchTo(targetInputMethod)

    -- 记录日志
    print(string.format("应用切换: %s -> 输入法: %s", appName, targetInputMethod))
end

-- 停止自动切换
function autoInputMethod.stop()
    if appWatcher then
        appWatcher:stop()
        appWatcher = nil
        alertManager.warning("自动输入法切换已停用")
    end
end

-- 重启自动切换
function autoInputMethod.restart()
    autoInputMethod.stop()
    autoInputMethod.init()
end

return autoInputMethod
