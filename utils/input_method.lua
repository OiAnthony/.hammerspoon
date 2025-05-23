-- 输入法工具函数
local inputMethod = {}
local alertManager = require("utils.alert_manager")

-- 获取当前输入法
function inputMethod.getCurrentInputMethod()
  return hs.keycodes.currentSourceID()
end

-- 切换到指定输入法
function inputMethod.switchTo(sourceID)
  if sourceID and sourceID ~= inputMethod.getCurrentInputMethod() then
    hs.keycodes.currentSourceID(sourceID)
    -- 使用静默提醒，默认不显示
    alertManager.inputMethodSwitch(sourceID)
  end
end

-- 检查应用是否在指定列表中
function inputMethod.isAppInList(appName, appList)
  for _, name in ipairs(appList) do
    if string.find(appName, name) then
      return true
    end
  end
  return false
end

-- 根据应用名称获取应该使用的输入法
function inputMethod.getInputMethodForApp(appName, constants)
  if inputMethod.isAppInList(appName, constants.IDE_APPS) then
    return constants.INPUT_METHODS.ENGLISH
  else
    return constants.INPUT_METHODS.DEFAULT
  end
end

-- 显示当前输入法状态
function inputMethod.showCurrentStatus()
  local current = inputMethod.getCurrentInputMethod()
  local status = "当前输入法: " .. current
  alertManager.info(status)
end

return inputMethod
