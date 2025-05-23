# Hammerspoon 配置

这是一个结构化的 Hammerspoon 配置，主要功能是根据当前应用自动切换输入法，并提供美化的提醒系统和统一的快捷键管理。

## 项目结构

```
.hammerspoon/
├── init.lua                    # 主配置文件
├── config/
│   ├── constants.lua          # 配置常量（输入法、应用列表等）
│   └── hotkeys.lua            # 快捷键配置（新增）
├── utils/
│   ├── input_method.lua       # 输入法工具函数
│   ├── app_info.lua          # 应用信息工具函数
│   ├── alert_manager.lua     # 美化的提醒系统管理器
│   └── hotkey_manager.lua    # 快捷键管理器（新增）
├── modules/
│   └── auto_input_method.lua  # 自动切换输入法核心模块
├── keybindings/
│   └── global.lua            # 全局快捷键绑定（重构）
├── docs/
│   └── hotkey_system.md      # 快捷键系统文档（新增）
└── README.md                 # 项目说明
```

## 功能特性

### 1. 自动切换输入法

- 当切换到 IDE 应用时，自动切换到英文输入法 (ABC)
- 当切换到其他应用时，自动切换到中文输入法（微信输入法）
- 支持的 IDE 应用包括：VS Code, Xcode, IntelliJ IDEA, WebStorm, PyCharm, Cursor 等

### 2. 美化的提醒系统

- **多种提醒样式**：成功（绿色）、信息（蓝色）、警告（橙色）、静默（灰色）、应用信息（深色）
- **智能提醒管理**：默认关闭频繁的输入法切换提醒，避免干扰
- **可配置显示**：可通过快捷键切换是否显示输入法切换提醒
- **现代化设计**：圆角、渐变、合适的字体和大小
- **小尺寸设计**：相比默认样式更加简洁，不会过度占用屏幕空间
- **系统字体**：使用 macOS 系统字体，确保兼容性和一致性

### 3. 统一快捷键管理系统 🆕

- **配置驱动**：所有快捷键在 `config/hotkeys.lua` 中统一定义
- **自动生成帮助**：启动时自动打印快捷键信息，无需手动维护
- **分类管理**：快捷键按功能分类组织（系统管理、应用信息、输入法管理、帮助）
- **API集成**：使用 Hammerspoon 的 `hs.hotkey.getHotkeys()` API 获取实际注册的快捷键
- **冲突检测**：自动检测快捷键是否与系统快捷键冲突
- **动态帮助**：运行时可通过快捷键显示帮助信息
- **美观显示**：使用 Unicode 符号显示快捷键（⌃⌥⇧⌘）

### 4. 快捷键操作

- `⌃⌥⇧⌘0`: 重新加载 Hammerspoon 配置
- `⌃⌥⇧⌘I`: 显示当前应用信息（名称、路径、Bundle ID、输入法）
- `⌃⌥⇧⌘T`: 切换输入法提醒显示状态
- `⌃⌥⇧⌘H`: 显示所有快捷键帮助信息 🆕

## 快捷键管理系统详解

### 主要优势

1. **单一数据源**：快捷键信息只需在 `config/hotkeys.lua` 中维护
2. **自动同步**：启动信息自动与实际配置同步，无需手动更新 print 语句
3. **易于扩展**：添加新快捷键只需修改配置文件
4. **错误检测**：自动检测配置问题和冲突
5. **用户友好**：提供美观的快捷键显示格式

### 添加新快捷键

在 `config/hotkeys.lua` 的 `definitions` 表中添加：

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

### 查看快捷键信息

- **启动时**：控制台自动显示所有快捷键信息
- **运行时**：按 `⌃⌥⇧⌘H` 显示快捷键帮助弹窗
- **API获取**：使用 `hs.hotkey.getHotkeys()` 获取实际注册的快捷键

## 提醒系统详解

### 提醒类型

1. **成功提醒** (绿色)：配置加载完成等成功操作
2. **信息提醒** (蓝色)：一般信息显示
3. **警告提醒** (橙色)：警告信息
4. **静默提醒** (灰色)：输入法切换等频繁操作（默认关闭）
5. **应用信息提醒** (深色)：详细的应用信息显示

### 提醒设置

- **默认状态**：输入法切换提醒关闭，避免频繁干扰
- **启动提醒**：显示配置加载状态
- **持续时间**：根据提醒类型自动调整显示时间
- **小尺寸设计**：
  - 全局默认字体大小：14（原默认 27）
  - 圆角半径：12（原默认 27）
  - 边框宽度：1.5（原默认 2）
  - 各类型提醒进一步优化尺寸

## 配置说明

### 修改输入法

在 `config/constants.lua` 中修改输入法标识符：

```lua
constants.INPUT_METHODS = {
    ENGLISH = "com.apple.keylayout.ABC",  -- 英文输入法
    CHINESE = "com.tencent.inputmethod.wetype.pinyin"  -- 微信输入法
}
```

### 添加/修改应用列表

在 `config/constants.lua` 中修改应用列表：

```lua
-- 需要使用英文输入法的应用
constants.IDE_APPS = {
    "Visual Studio Code",
    "Xcode",
    "Cursor",
    -- 添加更多应用...
}
```

### 自定义提醒设置

可以通过 alert 管理器调整提醒行为：

```lua
local alertManager = require("utils.alert_manager")

-- 启用输入法切换提醒
alertManager.enableInputMethodAlerts()

-- 禁用输入法切换提醒
alertManager.disableInputMethodAlerts()

-- 切换提醒状态
alertManager.toggleInputMethodAlerts()
```

## 安装和使用

1. 确保已安装 Hammerspoon
2. 将配置文件放置在 `~/.hammerspoon/` 目录下
3. 重新加载 Hammerspoon 配置或重启 Hammerspoon
4. 配置会自动生效，启动时会显示美化的加载提醒

## 获取输入法标识符

如果需要使用其他输入法，可以在 Hammerspoon 控制台中运行以下命令获取当前输入法的标识符：

```lua
hs.keycodes.currentSourceID()
```

## 故障排除

1. 如果自动切换不生效，请检查输入法标识符是否正确
2. 如果应用名称匹配不准确，可以在控制台查看应用的实际名称
3. 使用 `Cmd+Alt+Ctrl+I` 查看当前应用的详细信息，帮助调试
4. 使用 `Cmd+Alt+Ctrl+T` 切换输入法提醒显示，观察切换行为

## 扩展功能

这个配置结构支持轻松扩展：

- 在 `modules/` 目录下添加新的功能模块
- 在 `keybindings/` 目录下添加特定的快捷键配置
- 在 `utils/` 目录下添加通用工具函数
- 通过 `alert_manager.lua` 自定义提醒样式和行为

## 更新日志

### v3.0 - 统一快捷键管理系统 🆕

- **配置驱动的快捷键管理**：所有快捷键在 `config/hotkeys.lua` 中统一定义
- **自动生成启动信息**：使用 `hs.hotkey.getHotkeys()` API 自动获取快捷键信息，无需手动维护 print 语句
- **分类管理**：快捷键按功能分类组织（系统管理、应用信息、输入法管理、帮助）
- **冲突检测**：自动检测快捷键是否与系统快捷键冲突
- **动态帮助系统**：新增 `⌃⌥⇧⌘H` 快捷键显示帮助信息
- **美观显示格式**：使用 Unicode 符号显示快捷键（⌃⌥⇧⌘）
- **模块化重构**：重构 `keybindings/global.lua`，使用新的快捷键管理器
- **完整文档**：新增 `docs/hotkey_system.md` 详细说明快捷键系统

### v2.1 - 小尺寸优化

- 配置全局 `hs.alert.defaultStyle` 使 alert 更小更简洁
- 字体大小从默认 27 减小到 14，圆角从 27 减小到 12
- 各类型提醒都采用更合适的小尺寸设计
- 减少屏幕占用，提升用户体验
- 修复字体兼容性问题，使用系统认可的字体名称

### v2.0 - 美化提醒系统

- 新增美化的 alert 管理器
- 默认关闭频繁的输入法切换提醒
- 支持多种提醒样式和自定义配置
- 优化用户体验，减少干扰
