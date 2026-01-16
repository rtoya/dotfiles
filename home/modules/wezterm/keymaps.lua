local wezterm = require 'wezterm'
local act = wezterm.action
local M = {}

function M.apply_to_config(config)
  -- ============================================
  -- Leader Key
  -- ============================================
  config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

  -- ============================================
  -- キーバインド
  -- ============================================
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

    -- フルスクリーン
    { key = "Enter", mods = "CMD", action = act.ToggleFullScreen },
  }

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
end

return M
