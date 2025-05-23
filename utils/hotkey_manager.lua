-- 快捷键管理器
local hotkeyManager = {}

local alertManager = require("utils.alert_manager")
local hotkeysConfig = require("config.hotkeys")

-- 存储注册的快捷键对象
local registeredHotkeys = {}

-- 初始化快捷键管理器
function hotkeyManager.init()
  -- 清除之前的快捷键
  hotkeyManager.clear()

  -- 注册所有快捷键
  for _, hotkeyDef in ipairs(hotkeysConfig.definitions) do
    local hotkey = hs.hotkey.bind(hotkeyDef.mods, hotkeyDef.key, hotkeyDef.callback)
    if hotkey then
      table.insert(registeredHotkeys, {
        hotkey = hotkey,
        definition = hotkeyDef
      })
    else
      print("警告: 无法注册快捷键 " .. hotkeysConfig.getKeyString(hotkeyDef.mods, hotkeyDef.key))
    end
  end

  alertManager.startup("快捷键管理器已初始化，共注册 " .. #registeredHotkeys .. " 个快捷键")
end

-- 清除所有快捷键
function hotkeyManager.clear()
  for _, item in ipairs(registeredHotkeys) do
    item.hotkey:delete()
  end
  registeredHotkeys = {}
end

-- 获取所有活跃的快捷键（使用 Hammerspoon API）
function hotkeyManager.getActiveHotkeys()
  return hs.hotkey.getHotkeys()
end

-- 显示快捷键帮助信息
function hotkeyManager.showHelp()
  local helpText = "🔨 Hammerspoon 快捷键帮助\n\n"

  -- 按类别组织快捷键
  local grouped = hotkeysConfig.getByCategory()

  for category, hotkeys in pairs(grouped) do
    helpText = helpText .. "【" .. category .. "】\n"
    for _, hotkey in ipairs(hotkeys) do
      local keyStr = hotkeysConfig.getKeyString(hotkey.mods, hotkey.key)
      helpText = helpText .. "  " .. keyStr .. ": " .. hotkey.description .. "\n"
    end
    helpText = helpText .. "\n"
  end

  -- 显示活跃快捷键统计
  local activeHotkeys = hotkeyManager.getActiveHotkeys()
  helpText = helpText .. "当前活跃快捷键数量: " .. #activeHotkeys

  alertManager.info(helpText, 8)
end

-- 打印启动信息（控制台）
function hotkeyManager.printStartupInfo()
  print("=== Hammerspoon 快捷键信息 ===")

  -- 按类别显示快捷键
  local grouped = hotkeysConfig.getByCategory()

  for category, hotkeys in pairs(grouped) do
    print("【" .. category .. "】")
    for _, hotkey in ipairs(hotkeys) do
      local keyStr = hotkeysConfig.getKeyString(hotkey.mods, hotkey.key)
      print("  " .. keyStr .. ": " .. hotkey.description)
    end
    print()
  end

  -- 使用 API 获取实际活跃的快捷键数量
  local activeHotkeys = hotkeyManager.getActiveHotkeys()
  print("实际注册的快捷键数量: " .. #activeHotkeys)
  print("配置中的快捷键数量: " .. #hotkeysConfig.definitions)

  -- 如果数量不匹配，显示警告
  if #activeHotkeys ~= #hotkeysConfig.definitions then
    print("⚠️  注意: 实际注册数量与配置数量不匹配，可能存在快捷键冲突")
  end

  print("===============================")
end

-- 验证快捷键是否可分配
function hotkeyManager.validateHotkeys()
  local issues = {}

  for _, hotkeyDef in ipairs(hotkeysConfig.definitions) do
    if not hs.hotkey.assignable(hotkeyDef.mods, hotkeyDef.key) then
      local keyStr = hotkeysConfig.getKeyString(hotkeyDef.mods, hotkeyDef.key)
      table.insert(issues, keyStr .. " (可能与系统快捷键冲突)")
    end
  end

  if #issues > 0 then
    print("⚠️  快捷键冲突警告:")
    for _, issue in ipairs(issues) do
      print("  " .. issue)
    end
  end

  return #issues == 0
end

-- 获取快捷键统计信息
function hotkeyManager.getStats()
  local activeHotkeys = hotkeyManager.getActiveHotkeys()
  local grouped = hotkeysConfig.getByCategory()

  -- 计算分组数量
  local categoryCount = 0
  for _ in pairs(grouped) do
    categoryCount = categoryCount + 1
  end

  return {
    active = #activeHotkeys,
    configured = #hotkeysConfig.definitions,
    categories = categoryCount,
    registeredObjects = #registeredHotkeys
  }
end

return hotkeyManager
