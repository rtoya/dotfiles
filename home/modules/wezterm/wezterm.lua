local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ============================================
-- 基本設定
-- ============================================
config.automatically_reload_config = true
config.audible_bell = "Disabled"

-- ============================================
-- macOS IME対応
-- ============================================
-- macSKK: Control+Jで改行されないようにする
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"

-- ============================================
-- モジュール読み込み
-- ============================================
local appearance = require 'appearance'
local keymaps = require 'keymaps'
local statusbar = require 'statusbar'
local tab = require 'tab'
local utils = require 'utils'
local workspace = require 'workspace'
local opacity = require 'opacity'

-- 設定を適用
appearance.apply_to_config(config)
keymaps.apply_to_config(config)
statusbar.apply_to_config(config)
tab.apply_to_config(config)
utils.apply_to_config(config)
workspace.apply_to_config(config)
opacity.apply_to_config(config)

-- イベントハンドラーを設定
keymaps.setup_events()
statusbar.setup_events()
tab.setup_events()
utils.setup_events()
workspace.setup_events()
opacity.setup_events()

return config
