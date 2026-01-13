local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.audible_bell = "Disabled"

-- ============================================
-- Tokyo Night カラースキーム（完全版）
-- ============================================
config.colors = {
  foreground = "#c0caf5",
  background = "#1a1b26",
  cursor_bg = "#c0caf5",
  cursor_fg = "#1a1b26",
  cursor_border = "#c0caf5",
  selection_fg = "#c0caf5",
  selection_bg = "#33467c",
  scrollbar_thumb = "#292e42",
  split = "#7aa2f7",

  ansi = {
    "#15161e", -- black
    "#f7768e", -- red
    "#9ece6a", -- green
    "#e0af68", -- yellow
    "#7aa2f7", -- blue
    "#bb9af7", -- magenta
    "#7dcfff", -- cyan
    "#a9b1d6", -- white
  },
  brights = {
    "#414868", -- bright black
    "#f7768e", -- bright red
    "#9ece6a", -- bright green
    "#e0af68", -- bright yellow
    "#7aa2f7", -- bright blue
    "#bb9af7", -- bright magenta
    "#7dcfff", -- bright cyan
    "#c0caf5", -- bright white
  },

  tab_bar = {
    background = "#1a1b26",
    inactive_tab_edge = "none",
    active_tab = {
      bg_color = "#7aa2f7",
      fg_color = "#1a1b26",
    },
    inactive_tab = {
      bg_color = "#292e42",
      fg_color = "#565f89",
    },
    inactive_tab_hover = {
      bg_color = "#3b4261",
      fg_color = "#c0caf5",
    },
    new_tab = {
      bg_color = "#1a1b26",
      fg_color = "#7aa2f7",
    },
    new_tab_hover = {
      bg_color = "#3b4261",
      fg_color = "#c0caf5",
    },
  },
}

-- ============================================
-- Cursor
-- ============================================
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500

-- ============================================
-- Font
-- ============================================
config.font = wezterm.font_with_fallback({
  { family = "Hack Nerd Font", weight = "Regular", stretch = "Normal", style = "Normal" },
  { family = "Hiragino Sans", weight = "Regular" },
  { family = "Hiragino Kaku Gothic ProN", weight = "Regular" },
})
config.font_size = 12.0
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
config.selection_word_boundary = " \t\n{}[]()\"'`"
config.window_background_opacity = 0.80
config.macos_window_background_blur = 90

-- ============================================
-- Tab Bar
-- ============================================
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

-- タブタイトルフォーマット
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#292e42"
  local foreground = "#565f89"
  if tab.is_active then
    background = "#7aa2f7"
    foreground = "#1a1b26"
  elseif hover then
    background = "#3b4261"
    foreground = "#c0caf5"
  end

  local title = tab.active_pane.title
  if title and #title > max_width - 4 then
    title = wezterm.truncate_right(title, max_width - 4)
  end

  local index = tab.tab_index + 1
  return {
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = " " .. index .. ": " .. title .. " " },
  }
end)

-- ============================================
-- Pane 視覚的強化
-- ============================================
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.2,
}

-- ============================================
-- ステータスバー
-- ============================================
config.status_update_interval = 1000

wezterm.on("update-status", function(window, pane)
  -- 左側: ワークスペース名
  local workspace = window:active_workspace()
  local left_status = wezterm.format({
    { Foreground = { Color = "#7aa2f7" } },
    { Text = "  " .. workspace .. " " },
  })
  window:set_left_status(left_status)

  -- 右側: CWD + 時刻
  local cwd = pane:get_current_working_dir()
  local cwd_str = ""
  if cwd then
    cwd_str = cwd.file_path or ""
    -- ホームディレクトリを ~ に置換
    local home = os.getenv("HOME")
    if home and cwd_str:sub(1, #home) == home then
      cwd_str = "~" .. cwd_str:sub(#home + 1)
    end
  end

  local time = wezterm.strftime("%H:%M")
  local date = wezterm.strftime("%m/%d")

  local right_status = wezterm.format({
    { Foreground = { Color = "#565f89" } },
    { Text = " " .. cwd_str .. " " },
    { Foreground = { Color = "#3b4261" } },
    { Text = " | " },
    { Foreground = { Color = "#9ece6a" } },
    { Text = " " .. date .. " " },
    { Foreground = { Color = "#7aa2f7" } },
    { Text = " " .. time .. " " },
  })
  window:set_right_status(right_status)
end)

-- ============================================
-- キーバインド
-- ============================================
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  -- ペイン分割
  { key = "d", mods = "CMD", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "d", mods = "CMD|SHIFT", action = act.SplitVertical { domain = "CurrentPaneDomain" } },

  -- ペイン間移動
  { key = "LeftArrow", mods = "CMD|OPT", action = act.ActivatePaneDirection "Left" },
  { key = "RightArrow", mods = "CMD|OPT", action = act.ActivatePaneDirection "Right" },
  { key = "UpArrow", mods = "CMD|OPT", action = act.ActivatePaneDirection "Up" },
  { key = "DownArrow", mods = "CMD|OPT", action = act.ActivatePaneDirection "Down" },

  -- ペインサイズ調整
  { key = "LeftArrow", mods = "CMD|CTRL", action = act.AdjustPaneSize { "Left", 5 } },
  { key = "RightArrow", mods = "CMD|CTRL", action = act.AdjustPaneSize { "Right", 5 } },
  { key = "UpArrow", mods = "CMD|CTRL", action = act.AdjustPaneSize { "Up", 5 } },
  { key = "DownArrow", mods = "CMD|CTRL", action = act.AdjustPaneSize { "Down", 5 } },

  -- ペインを閉じる
  { key = "w", mods = "CMD", action = act.CloseCurrentPane { confirm = true } },

  -- ペインズーム（トグル）
  { key = "z", mods = "CMD", action = act.TogglePaneZoomState },

  -- タブ操作
  { key = "t", mods = "CMD", action = act.SpawnTab "CurrentPaneDomain" },
  { key = "[", mods = "CMD|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "CMD|SHIFT", action = act.ActivateTabRelative(1) },
  { key = "{", mods = "CMD|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "CMD|SHIFT", action = act.MoveTabRelative(1) },

  -- タブ番号で直接移動
  { key = "1", mods = "CMD", action = act.ActivateTab(0) },
  { key = "2", mods = "CMD", action = act.ActivateTab(1) },
  { key = "3", mods = "CMD", action = act.ActivateTab(2) },
  { key = "4", mods = "CMD", action = act.ActivateTab(3) },
  { key = "5", mods = "CMD", action = act.ActivateTab(4) },
  { key = "6", mods = "CMD", action = act.ActivateTab(5) },
  { key = "7", mods = "CMD", action = act.ActivateTab(6) },
  { key = "8", mods = "CMD", action = act.ActivateTab(7) },
  { key = "9", mods = "CMD", action = act.ActivateTab(-1) },

  -- フォントサイズ
  { key = "+", mods = "CMD", action = act.IncreaseFontSize },
  { key = "-", mods = "CMD", action = act.DecreaseFontSize },
  { key = "0", mods = "CMD", action = act.ResetFontSize },

  -- Quick Select
  { key = "Space", mods = "CMD|SHIFT", action = act.QuickSelect },

  -- コマンドパレット
  { key = "p", mods = "CMD|SHIFT", action = act.ActivateCommandPalette },

  -- コピーモード
  { key = "c", mods = "CMD|SHIFT", action = act.ActivateCopyMode },

  -- 検索
  { key = "f", mods = "CMD", action = act.Search { CaseInSensitiveString = "" } },

  -- スクロール
  { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
  { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },

  -- ワークスペース
  { key = "s", mods = "CMD|SHIFT", action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },
  { key = "n", mods = "CMD|SHIFT", action = act.SwitchToWorkspace },

  -- デバッグオーバーレイ
  { key = "l", mods = "CMD|SHIFT", action = act.ShowDebugOverlay },

  -- 設定リロード
  { key = "r", mods = "CMD|SHIFT", action = act.ReloadConfiguration },
}

-- ============================================
-- Quick Select パターン
-- ============================================
config.quick_select_patterns = {
  -- Git ハッシュ (短縮・フル)
  "[0-9a-f]{7,40}",
  -- IPv4
  "\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}",
  -- UUID
  "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",
  -- ファイルパス
  "(?:/[\\w.-]+)+",
  "~(?:/[\\w.-]+)+",
}

-- ============================================
-- ハイパーリンク
-- ============================================
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- ファイルパスをクリック可能に
table.insert(config.hyperlink_rules, {
  regex = "\\b(/[\\w.-]+)+\\b",
  format = "file://$0",
})

-- Gitハブのissue/PR参照
table.insert(config.hyperlink_rules, {
  regex = [[\b([A-Za-z0-9_-]+/[A-Za-z0-9_-]+)#(\d+)\b]],
  format = "https://github.com/$1/issues/$2",
})

-- ============================================
-- マウス操作
-- ============================================
config.mouse_bindings = {
  -- 右クリックでペースト
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom "Clipboard",
  },
  -- Cmd+クリックでリンクを開く
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = act.OpenLinkAtMouseCursor,
  },
  -- トリプルクリックで行全体選択
  {
    event = { Down = { streak = 3, button = "Left" } },
    mods = "NONE",
    action = act.SelectTextAtMouseCursor "Line",
  },
}

-- ============================================
-- 通知設定
-- ============================================
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 150,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 150,
}
config.colors.visual_bell = "#3b4261"

-- ベル発生時に通知
wezterm.on("bell", function(window, pane)
  window:toast_notification("Wezterm", "Bell in " .. pane:get_title(), nil, 4000)
end)

-- ============================================
-- その他
-- ============================================
config.scrollback_lines = 10000
config.enable_scroll_bar = true
config.check_for_updates = false

return config
