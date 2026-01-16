local wezterm = require 'wezterm'
local act = wezterm.action
local M = {}

-- ============================================
-- ペインサイズ調整ヘルパー関数
-- ============================================

-- ペインの高さをパーセンテージで設定
local function set_pane_height_percent(window, pane, percent)
  local tab = window:active_tab()
  local tab_size = tab:get_size()
  local target_rows = math.floor(tab_size.rows * percent / 100)
  local pane_info = pane:tab():get_pane_direction("Up")

  -- ペインが上にあるか下にあるかで方向を決定
  local direction = pane_info and "Down" or "Up"
  local current_rows = pane:get_dimensions().viewport_rows
  local diff = target_rows - current_rows

  if diff ~= 0 then
    window:perform_action(
      act.AdjustPaneSize { direction, math.abs(diff) },
      pane
    )
  end
end

-- ペインの幅をパーセンテージで設定
local function set_pane_width_percent(window, pane, percent)
  local tab = window:active_tab()
  local tab_size = tab:get_size()
  local target_cols = math.floor(tab_size.cols * percent / 100)
  local pane_info = pane:tab():get_pane_direction("Left")

  -- ペインが左にあるか右にあるかで方向を決定
  local direction = pane_info and "Right" or "Left"
  local current_cols = pane:get_dimensions().cols
  local diff = target_cols - current_cols

  if diff ~= 0 then
    window:perform_action(
      act.AdjustPaneSize { direction, math.abs(diff) },
      pane
    )
  end
end

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

    -- macOS IME対応: Alt+¥ でバックスラッシュを入力
    { key = "¥", mods = "ALT", action = act.SendString("\\") },

    -- ============================================
    -- Leader キーバインド
    -- ============================================

    -- Setting Mode 起動
    { key = "s", mods = "LEADER", action = act.ActivateKeyTable { name = "setting_mode", one_shot = false } },

    -- 直前のコマンドと出力をコピー (Leader+z)
    {
      key = "z",
      mods = "LEADER",
      action = act.Multiple {
        act.ActivateCopyMode,
        act.CopyMode { SetSelectionMode = "SemanticZone" },
        act.CopyMode "MoveBackwardSemanticZone",
        act.CopyMode { SetSelectionMode = "SemanticZone" },
        act.CopyMode "MoveForwardSemanticZone",
        act.CopyMode "MoveUp",
        act.CopyMode { SetSelectionMode = "Cell" },
        act.CopyMode "MoveToEndOfLineContent",
        act.CopyMode { JumpBackward = { prev_char = false } },
        act.CopyMode { SetSelectionMode = "Block" },
        act.CopyMode { MoveByPage = -0.5 },
        act { CopyTo = "ClipboardAndPrimarySelection" },
        act.CopyMode "Close",
        act.EmitEvent "show-copied-notification",
      },
    },

    -- バッファをNeovimで表示 (Leader+b)
    {
      key = "b",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        local pane_id = pane:pane_id()
        window:perform_action(
          act.SplitPane {
            direction = "Right",
            command = {
              args = { "nvim", "-c", "WezCapture " .. pane_id },
            },
          },
          pane
        )
        -- 新しいペインをアクティブにしてズーム
        window:perform_action(act.ActivatePaneDirection "Right", pane)
        window:perform_action(act.TogglePaneZoomState, window:active_pane())
      end),
    },
  }

  -- ============================================
  -- Setting Mode キーテーブル
  -- ============================================
  config.key_tables = config.key_tables or {}
  config.key_tables.setting_mode = {
    -- hjkl で1単位ずつサイズ調整
    { key = "h", action = act.AdjustPaneSize { "Left", 1 } },
    { key = "j", action = act.AdjustPaneSize { "Down", 1 } },
    { key = "k", action = act.AdjustPaneSize { "Up", 1 } },
    { key = "l", action = act.AdjustPaneSize { "Right", 1 } },

    -- 数字キーで高さをパーセンテージ指定
    { key = "1", action = act.EmitEvent "set-height-10" },
    { key = "2", action = act.EmitEvent "set-height-20" },
    { key = "3", action = act.EmitEvent "set-height-30" },
    { key = "4", action = act.EmitEvent "set-height-40" },
    { key = "5", action = act.EmitEvent "set-height-50" },
    { key = "6", action = act.EmitEvent "set-height-60" },
    { key = "7", action = act.EmitEvent "set-height-70" },
    { key = "8", action = act.EmitEvent "set-height-80" },
    { key = "9", action = act.EmitEvent "set-height-90" },

    -- Ctrl+数字キーで幅をパーセンテージ指定
    { key = "1", mods = "CTRL", action = act.EmitEvent "set-width-10" },
    { key = "2", mods = "CTRL", action = act.EmitEvent "set-width-20" },
    { key = "3", mods = "CTRL", action = act.EmitEvent "set-width-30" },
    { key = "4", mods = "CTRL", action = act.EmitEvent "set-width-40" },
    { key = "5", mods = "CTRL", action = act.EmitEvent "set-width-50" },
    { key = "6", mods = "CTRL", action = act.EmitEvent "set-width-60" },
    { key = "7", mods = "CTRL", action = act.EmitEvent "set-width-70" },
    { key = "8", mods = "CTRL", action = act.EmitEvent "set-width-80" },
    { key = "9", mods = "CTRL", action = act.EmitEvent "set-width-90" },

    -- モード終了
    { key = "Escape", action = "PopKeyTable" },
    { key = "q", action = "PopKeyTable" },
    { key = "c", mods = "CTRL", action = "PopKeyTable" },
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

function M.setup_events()
  -- コピー完了通知
  wezterm.on("show-copied-notification", function(window, pane)
    window:toast_notification("WezTerm", "Copied!", nil, 3000)
  end)

  -- 高さパーセンテージ設定イベント
  for i = 1, 9 do
    local percent = i * 10
    wezterm.on("set-height-" .. percent, function(window, pane)
      set_pane_height_percent(window, pane, percent)
      -- Setting Modeを維持
      window:perform_action(
        act.ActivateKeyTable { name = "setting_mode", one_shot = false },
        pane
      )
    end)
  end

  -- 幅パーセンテージ設定イベント
  for i = 1, 9 do
    local percent = i * 10
    wezterm.on("set-width-" .. percent, function(window, pane)
      set_pane_width_percent(window, pane, percent)
      -- Setting Modeを維持
      window:perform_action(
        act.ActivateKeyTable { name = "setting_mode", one_shot = false },
        pane
      )
    end)
  end
end

return M
