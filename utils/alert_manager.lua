-- Alert 管理器 - 美化的提醒系统
local alertManager = {}

-- 配置全局默认样式，使 alert 更小
hs.alert.defaultStyle = {
    strokeWidth = 1.5,
    strokeColor = { white = 1, alpha = 0.8 },
    fillColor = { white = 0, alpha = 0.8 },
    textColor = { white = 1, alpha = 1 },
    textFont = ".AppleSystemUIFont", -- 使用系统默认字体
    textSize = 14,                   -- 从默认的 27 减小到 14
    radius = 12,                     -- 从默认的 27 减小到 12
    atScreenEdge = 0,
    fadeInDuration = 0.2,
    fadeOutDuration = 0.2,
    padding = nil,
}

-- Alert 样式配置
local styles = {
    -- 成功提醒（绿色）
    success = {
        fillColor = { red = 0.2, green = 0.8, blue = 0.4, alpha = 0.85 },
        strokeColor = { red = 0.1, green = 0.6, blue = 0.3, alpha = 0.9 },
        strokeWidth = 1.5,
        radius = 10,
        textColor = { red = 1, green = 1, blue = 1, alpha = 1 },
        textFont = ".AppleSystemUIFont",
        textSize = 13,
        fadeInDuration = 0.2,
        fadeOutDuration = 0.3
    },

    -- 信息提醒（蓝色）
    info = {
        fillColor = { red = 0.2, green = 0.6, blue = 0.9, alpha = 0.85 },
        strokeColor = { red = 0.1, green = 0.4, blue = 0.7, alpha = 0.9 },
        strokeWidth = 1.5,
        radius = 10,
        textColor = { red = 1, green = 1, blue = 1, alpha = 1 },
        textFont = ".AppleSystemUIFont",
        textSize = 13,
        fadeInDuration = 0.2,
        fadeOutDuration = 0.3
    },

    -- 警告提醒（橙色）
    warning = {
        fillColor = { red = 0.9, green = 0.6, blue = 0.2, alpha = 0.85 },
        strokeColor = { red = 0.7, green = 0.4, blue = 0.1, alpha = 0.9 },
        strokeWidth = 1.5,
        radius = 10,
        textColor = { red = 1, green = 1, blue = 1, alpha = 1 },
        textFont = ".AppleSystemUIFont",
        textSize = 13,
        fadeInDuration = 0.2,
        fadeOutDuration = 0.3
    },

    -- 静默提醒（灰色，更小尺寸）
    silent = {
        fillColor = { red = 0.3, green = 0.3, blue = 0.3, alpha = 0.7 },
        strokeColor = { red = 0.2, green = 0.2, blue = 0.2, alpha = 0.8 },
        strokeWidth = 1,
        radius = 8,
        textColor = { red = 1, green = 1, blue = 1, alpha = 0.9 },
        textFont = ".AppleSystemUIFont",
        textSize = 11,
        fadeInDuration = 0.1,
        fadeOutDuration = 0.2
    },

    -- 输入法切换提醒（右下角显示）
    inputMethod = {
        fillColor = { red = 0.2, green = 0.2, blue = 0.2, alpha = 0.8 },
        strokeColor = { red = 0.4, green = 0.4, blue = 0.4, alpha = 0.9 },
        strokeWidth = 1,
        radius = 6,
        textColor = { red = 1, green = 1, blue = 1, alpha = 0.95 },
        textFont = ".AppleSystemUIFont",
        textSize = 10,
        fadeInDuration = 0.1,
        fadeOutDuration = 0.15
    },

    -- 应用信息提醒（深色主题，适中尺寸）
    appInfo = {
        fillColor = { red = 0.1, green = 0.1, blue = 0.1, alpha = 0.9 },
        strokeColor = { red = 0.3, green = 0.3, blue = 0.3, alpha = 0.9 },
        strokeWidth = 1.5,
        radius = 12,
        textColor = { red = 0.9, green = 0.9, blue = 0.9, alpha = 1 },
        textFont = "Menlo", -- 使用等宽字体显示应用信息
        textSize = 12,
        fadeInDuration = 0.3,
        fadeOutDuration = 0.4
    }
}

-- 设置
local settings = {
    enableInputMethodAlerts = true, -- 默认开启输入法切换提醒
    enableStartupAlerts = true,     -- 启动提醒
    silentDuration = 0.8,           -- 静默提醒持续时间
    normalDuration = 2,             -- 普通提醒持续时间
    longDuration = 4                -- 长提醒持续时间
}

-- 显示美化的 alert
function alertManager.show(message, style, duration)
    style = style or "info"
    duration = duration or settings.normalDuration

    local alertStyle = styles[style] or styles.info

    -- 使用 hs.alert.show 的高级参数
    hs.alert.show(message, alertStyle, duration)
end

-- 显示右下角 alert（专门用于输入法切换）
function alertManager.showAtBottom(message, style, duration)
    style = style or "inputMethod"
    duration = duration or settings.silentDuration

    local alertStyle = styles[style] or styles.inputMethod

    -- 创建右下角显示的样式，使用 atScreenEdge = 2 表示底部边缘
    local bottomRightStyle = {}
    for k, v in pairs(alertStyle) do
        bottomRightStyle[k] = v
    end
    bottomRightStyle.atScreenEdge = 2 -- 2 表示底部边缘

    -- 使用官方的 hs.alert.show API
    return hs.alert.show(message, bottomRightStyle, duration)
end

-- 成功提醒
function alertManager.success(message, duration)
    alertManager.show("✅ " .. message, "success", duration or settings.normalDuration)
end

-- 信息提醒
function alertManager.info(message, duration)
    alertManager.show("ℹ️ " .. message, "info", duration or settings.normalDuration)
end

-- 警告提醒
function alertManager.warning(message, duration)
    alertManager.show("⚠️ " .. message, "warning", duration or settings.normalDuration)
end

-- 静默提醒（用于频繁操作，如输入法切换）
function alertManager.silent(message, duration)
    if settings.enableInputMethodAlerts then
        alertManager.show(message, "silent", duration or settings.silentDuration)
    end
end

-- 应用信息提醒
function alertManager.appInfo(message, duration)
    alertManager.show(message, "appInfo", duration or settings.longDuration)
end

-- 输入法切换提醒（右下角显示）
function alertManager.inputMethodSwitch(inputMethod)
    if settings.enableInputMethodAlerts then
        local message = "⌨️ " .. inputMethod
        alertManager.showAtBottom(message, "inputMethod", settings.silentDuration)
    end
end

-- 启动提醒
function alertManager.startup(message)
    if settings.enableStartupAlerts then
        alertManager.success(message, settings.normalDuration)
    end
end

-- 配置管理
function alertManager.enableInputMethodAlerts()
    settings.enableInputMethodAlerts = true
    alertManager.info("输入法切换提醒已启用")
end

function alertManager.disableInputMethodAlerts()
    settings.enableInputMethodAlerts = false
    alertManager.info("输入法切换提醒已禁用")
end

function alertManager.toggleInputMethodAlerts()
    if settings.enableInputMethodAlerts then
        alertManager.disableInputMethodAlerts()
    else
        alertManager.enableInputMethodAlerts()
    end
end

-- 获取当前设置
function alertManager.getSettings()
    return settings
end

-- 更新设置
function alertManager.updateSettings(newSettings)
    for key, value in pairs(newSettings) do
        if settings[key] ~= nil then
            settings[key] = value
        end
    end
end

return alertManager
