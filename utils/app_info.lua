-- 应用信息工具函数
local appInfo = {}
local alertManager = require("utils.alert_manager")

-- 获取当前活跃应用的信息
function appInfo.getCurrentAppInfo()
  local app = hs.application.frontmostApplication()
  if not app then
    return nil
  end

  local appName = app:name() or "Unknown"
  local appPath = app:path() or "Unknown"
  local bundleID = app:bundleID() or "Unknown"

  return {
    name = appName,
    path = appPath,
    bundleID = bundleID
  }
end

-- 格式化应用信息为显示文本
function appInfo.formatAppInfo(info)
  if not info then
    return "无法获取应用信息"
  end

  local text = string.format(
    "应用名称: %s\n应用路径: %s\nBundle ID: %s",
    info.name,
    info.path,
    info.bundleID
  )

  return text
end

-- 显示当前应用信息（包含输入法）
function appInfo.showCurrentAppInfo()
  local info = appInfo.getCurrentAppInfo()
  local currentIM = hs.keycodes.currentSourceID()

  local message
  if info then
    message = string.format(
      "📱 应用名称: %s\n📁 应用路径: %s\n🆔 Bundle ID: %s\n⌨️ 当前输入法: %s",
      info.name,
      info.path,
      info.bundleID,
      currentIM
    )
  else
    message = string.format("⌨️ 当前输入法: %s\n❌ 无法获取应用信息", currentIM)
  end

  -- 使用专门的应用信息样式
  alertManager.appInfo(message)

  -- 同时打印到控制台
  print("=== 当前应用信息 ===")
  if info then
    print("应用名称:", info.name)
    print("应用路径:", info.path)
    print("Bundle ID:", info.bundleID)
  end
  print("当前输入法:", currentIM)
  print("==================")
end

return appInfo
