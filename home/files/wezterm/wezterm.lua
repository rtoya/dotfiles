local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.audible_bell = "Disabled"

-- Color
config.colors = {
  background = "#1a1b26",
  foreground = "#c0caf5",
}

-- Cursor
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500

-- Font
config.font = wezterm.font_with_fallback({
  { family = "Hack Nerd Font", weight = "Regular", stretch = "Normal", style = "Normal" },
  { family = "Hiragino Sans", weight = "Regular" },
  { family = "Hiragino Kaku Gothic ProN", weight = "Regular" },
})
config.font_size = 12.0
config.line_height = 1.3
config.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  bottom = 2,
}
config.use_ime = true

-- 選択時の単語境界設定
config.selection_word_boundary = " \t\n{}[]()\"'`"

config.window_background_opacity = 0.80
config.macos_window_background_blur = 90

-- Tabs
local title_cache = {}
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 40
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.window_background_gradient = {
  colors = { "#000000" },
}
config.show_new_tab_button_in_tab_bar = false
config.colors.tab_bar = {
  inactive_tab_edge = "none",
}
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#3b4261"
  local foreground = "#c0caf5"
  if tab.is_active then
    background = "#7aa2f7"
    foreground = "#1a1b26"
  end

  -- キャッシュからGitブランチ情報を取得
  local pane_id = tab.active_pane.pane_id
  local title = title_cache[pane_id] or tab.active_pane.title

  -- タブの最小幅を確保（Gitブランチ情報が表示されるように）
  local desired_width = math.max(max_width, 40)
  title = wezterm.truncate_right(title, desired_width - 1)
  return {
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = " " .. title .. " " },
  }
end)

-- Pane


return config
