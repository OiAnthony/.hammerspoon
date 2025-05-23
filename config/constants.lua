-- 配置常量
local constants = {}

-- 输入法配置
constants.INPUT_METHODS = {
    ENGLISH = "com.apple.keylayout.ABC",       -- 英文输入法
    CHINESE = "com.tencent.inputmethod.wetype.pinyin", -- 微信输入法
    DEFAULT = "com.tencent.inputmethod.wetype.pinyin" -- 默认输入法
}

-- IDE 应用列表 (需要使用英文输入法的应用)
constants.IDE_APPS = {
    "Visual Studio Code",
    "Xcode",
    "IntelliJ IDEA",
    "WebStorm",
    "PyCharm",
    "Android Studio",
    "Sublime Text",
    "Atom",
    "Vim",
    "MacVim",
    "Neovim",
    "Terminal",
    "iTerm2",
    "Cursor"
}

-- 快捷键配置
constants.HYPER_KEY =  { "ctrl", "alt", "cmd", "shift" }

return constants
