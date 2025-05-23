-- 快捷键配置
local hotkeys = {}

local constants = require("config.constants")

-- 快捷键定义
-- 格式: { mods, key, description, callback, category }
hotkeys.definitions = {
  -- 系统管理类
  {
    mods = constants.HYPER_KEY,
    key = "0",
    description = "重新加载 Hammerspoon 配置",
    category = "系统管理",
    callback = function()
      local alertManager = require("utils.alert_manager")
      alertManager.info("重新加载配置中...", 1)
      hs.reload()
    end
  },

  -- 应用信息类
  {
    mods = constants.HYPER_KEY,
    key = "i",
    description = "显示当前应用信息（名称、路径、输入法）",
    category = "应用信息",
    callback = function()
      local appInfo = require("utils.app_info")
      appInfo.showCurrentAppInfo()
    end
  },

  -- -- 输入法管理类
  -- {
  --   mods = constants.HYPER_KEY,
  --   key = "t",
  --   description = "切换输入法提醒显示状态",
  --   category = "输入法管理",
  --   callback = function()
  --     local alertManager = require("utils.alert_manager")
  --     alertManager.toggleInputMethodAlerts()
  --   end
  -- },

  -- 快捷键帮助
  {
    mods = constants.HYPER_KEY,
    key = "h",
    description = "显示所有快捷键帮助信息",
    category = "帮助",
    callback = function()
      local hotkeyManager = require("utils.hotkey_manager")
      hotkeyManager.showHelp()
    end
  }
}

-- 获取按类别分组的快捷键
function hotkeys.getByCategory()
  local grouped = {}
  for _, hotkey in ipairs(hotkeys.definitions) do
    if not grouped[hotkey.category] then
      grouped[hotkey.category] = {}
    end
    table.insert(grouped[hotkey.category], hotkey)
  end
  return grouped
end

-- 获取快捷键的字符串表示
function hotkeys.getKeyString(mods, key)
  local modStrings = {}
  local modMap = {
    cmd = "⌘",
    ctrl = "⌃",
    alt = "⌥",
    shift = "⇧"
  }

  -- 按固定顺序排列修饰键
  local order = { "ctrl", "alt", "shift", "cmd" }
  for _, mod in ipairs(order) do
    for _, m in ipairs(mods) do
      if m == mod or m == "command" and mod == "cmd" or m == "option" and mod == "alt" then
        table.insert(modStrings, modMap[mod])
        break
      end
    end
  end

  return table.concat(modStrings, "") .. key:upper()
end

return hotkeys
