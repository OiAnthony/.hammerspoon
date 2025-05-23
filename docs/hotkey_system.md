# 快捷键管理系统

## 概述

新的快捷键管理系统提供了统一的快捷键配置和管理方式，避免了在多个地方维护快捷键信息的问题。

## 特性

- **统一配置**: 所有快捷键在 `config/hotkeys.lua` 中统一定义
- **自动生成帮助**: 启动时自动打印快捷键信息，无需手动维护
- **分类管理**: 快捷键按功能分类组织
- **API集成**: 使用 Hammerspoon 的 `hs.hotkey.getHotkeys()` API 获取实际注册的快捷键
- **冲突检测**: 自动检测快捷键是否与系统快捷键冲突
- **动态帮助**: 运行时可通过快捷键显示帮助信息

## 文件结构

```
config/
  hotkeys.lua          # 快捷键配置文件
utils/
  hotkey_manager.lua   # 快捷键管理器
keybindings/
  global.lua           # 全局快捷键绑定（简化版）
```

## 使用方法

### 添加新快捷键

在 `config/hotkeys.lua` 的 `definitions` 表中添加新的快捷键定义：

```lua
{
    mods = {"cmd", "alt"},
    key = "n",
    description = "新功能描述",
    category = "功能分类",
    callback = function()
        -- 快捷键回调函数
    end
}
```

### 查看快捷键帮助

- **启动时**: 自动在控制台打印所有快捷键信息
- **运行时**: 按 `⌃⌥⇧⌘H` 显示快捷键帮助弹窗

### 快捷键格式

快捷键使用以下格式显示：

- `⌃` = Ctrl
- `⌥` = Alt/Option  
- `⇧` = Shift
- `⌘` = Cmd/Command

## API 参考

### hotkeyManager

- `init()`: 初始化快捷键管理器
- `clear()`: 清除所有快捷键
- `getActiveHotkeys()`: 获取当前活跃的快捷键
- `showHelp()`: 显示快捷键帮助
- `printStartupInfo()`: 打印启动信息
- `validateHotkeys()`: 验证快捷键是否可用
- `getStats()`: 获取快捷键统计信息

### hotkeysConfig

- `definitions`: 快捷键定义数组
- `getByCategory()`: 按分类获取快捷键
- `getKeyString(mods, key)`: 获取快捷键的字符串表示

## 当前快捷键

系统会在启动时自动显示当前配置的所有快捷键，包括：

- **系统管理**: 重新加载配置
- **应用信息**: 显示当前应用信息
- **输入法管理**: 切换输入法提醒
- **帮助**: 显示快捷键帮助

## 优势

1. **单一数据源**: 快捷键信息只需在一个地方维护
2. **自动同步**: 启动信息自动与实际配置同步
3. **易于扩展**: 添加新快捷键只需修改配置文件
4. **错误检测**: 自动检测配置问题和冲突
5. **用户友好**: 提供美观的快捷键显示格式
