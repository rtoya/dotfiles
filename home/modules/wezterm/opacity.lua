local wezterm = require 'wezterm'
local act = wezterm.action
local M = {}

-- ============================================
-- 透明度調整モジュール
-- Setting Modeで透明度を動的に変更
-- ============================================

function M.apply_to_config(config)
  -- setting_mode キーテーブルに透明度調整キーを追加
  if config.key_tables and config.key_tables.setting_mode then
    table.insert(config.key_tables.setting_mode, { key = ";", action = act.EmitEvent("increase-opacity") })
    table.insert(config.key_tables.setting_mode, { key = "-", action = act.EmitEvent("decrease-opacity") })
    table.insert(config.key_tables.setting_mode, { key = "0", action = act.EmitEvent("reset-opacity") })
  end
end

-- Setting Modeを再有効化
local function reactivate_setting_mode(window)
  window:perform_action(
    act.ActivateKeyTable { name = "setting_mode", one_shot = false },
    window:active_pane()
  )
end

-- 透明度を調整
local function adjust_opacity(window, delta, config)
  local overrides = window:get_config_overrides() or {}
  local current = overrides.window_background_opacity or config.window_background_opacity or 1.0

  local new_opacity = current + delta
  new_opacity = math.max(0.1, math.min(1.0, new_opacity))

  overrides.window_background_opacity = new_opacity
  window:set_config_overrides(overrides)

  reactivate_setting_mode(window)
end

function M.setup_events()
  -- 透明度増加
  wezterm.on("increase-opacity", function(window, pane)
    local config = window:effective_config()
    adjust_opacity(window, 0.1, config)
  end)

  -- 透明度減少
  wezterm.on("decrease-opacity", function(window, pane)
    local config = window:effective_config()
    adjust_opacity(window, -0.1, config)
  end)

  -- 透明度リセット
  wezterm.on("reset-opacity", function(window, pane)
    local config = window:effective_config()
    local overrides = window:get_config_overrides() or {}
    overrides.window_background_opacity = config.window_background_opacity
    window:set_config_overrides(overrides)

    reactivate_setting_mode(window)
  end)
end

return M
