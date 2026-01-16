local wezterm = require 'wezterm'
local M = {}

function M.apply_to_config(config)
  -- ============================================
  -- カラースキーム
  -- ============================================
  config.color_scheme = "Solarized Dark Higher Contrast"

  -- ============================================
  -- Cursor
  -- ============================================
  config.default_cursor_style = "BlinkingBlock"
  config.cursor_blink_rate = 500

  -- ============================================
  -- Font
  -- ============================================
  config.font_dirs = { wezterm.home_dir .. "/Library/Fonts/hackgen-nf" }
  config.font = wezterm.font("HackGen Console NF")
  config.font_size = 13.0
  config.line_height = 1.3

  -- ============================================
  -- Window
  -- ============================================
  config.window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2,
  }
  config.use_ime = true
  config.ime_preedit_rendering = "Builtin"
  config.selection_word_boundary = " \t\n{}[]()\"'`"
  config.window_background_opacity = 0.80
  config.macos_window_background_blur = 90

  -- ============================================
  -- Pane 視覚的強化
  -- ============================================
  config.inactive_pane_hsb = {
    saturation = 0.5,
    brightness = 0.2,
  }

  -- ============================================
  -- Visual Bell
  -- ============================================
  config.visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 150,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 150,
  }
end

return M
