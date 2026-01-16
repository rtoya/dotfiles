local wezterm = require 'wezterm'
local act = wezterm.action
local M = {}

-- ============================================
-- スクラッチワークスペース管理
-- ============================================

local previous_workspace = nil

-- スクラッチワークスペースとの切り替え
local function toggle_scratch_workspace(window, pane)
  local current_workspace = window:active_workspace()

  if current_workspace == "scratch" then
    -- scratchから前のワークスペースに戻る
    local target = previous_workspace or "default"
    window:perform_action(
      act.SwitchToWorkspace { name = target },
      pane
    )
  else
    -- 現在のワークスペースを保存してscratchへ移動
    previous_workspace = current_workspace
    window:perform_action(
      act.SwitchToWorkspace { name = "scratch" },
      pane
    )
  end
end

-- ワークスペース一覧を取得（scratchを除外）
local function get_workspaces_without_scratch()
  local workspaces = {}
  for _, ws in ipairs(wezterm.mux.get_workspace_names()) do
    if ws ~= "scratch" then
      table.insert(workspaces, ws)
    end
  end
  return workspaces
end

-- 次のワークスペースへ移動（scratchをスキップ）
local function switch_to_next_workspace_skip_scratch(window, pane)
  local workspaces = get_workspaces_without_scratch()
  if #workspaces == 0 then
    return
  end

  local current = window:active_workspace()
  local current_index = nil

  for i, ws in ipairs(workspaces) do
    if ws == current then
      current_index = i
      break
    end
  end

  if current_index then
    local next_index = (current_index % #workspaces) + 1
    window:perform_action(
      act.SwitchToWorkspace { name = workspaces[next_index] },
      pane
    )
  else
    -- 現在のワークスペースがリストにない場合（scratchにいる場合など）
    window:perform_action(
      act.SwitchToWorkspace { name = workspaces[1] },
      pane
    )
  end
end

-- 前のワークスペースへ移動（scratchをスキップ）
local function switch_to_prev_workspace_skip_scratch(window, pane)
  local workspaces = get_workspaces_without_scratch()
  if #workspaces == 0 then
    return
  end

  local current = window:active_workspace()
  local current_index = nil

  for i, ws in ipairs(workspaces) do
    if ws == current then
      current_index = i
      break
    end
  end

  if current_index then
    local prev_index = ((current_index - 2) % #workspaces) + 1
    window:perform_action(
      act.SwitchToWorkspace { name = workspaces[prev_index] },
      pane
    )
  else
    -- 現在のワークスペースがリストにない場合
    window:perform_action(
      act.SwitchToWorkspace { name = workspaces[#workspaces] },
      pane
    )
  end
end

function M.apply_to_config(config)
  -- ============================================
  -- ワークスペース関連キーバインドを追加
  -- ============================================
  config.keys = config.keys or {}

  -- スクラッチワークスペーストグル (Ctrl+Cmd+S)
  table.insert(config.keys, {
    key = "s",
    mods = "CTRL|CMD",
    action = wezterm.action_callback(toggle_scratch_workspace),
  })

  -- 次のワークスペースへ (Ctrl+Cmd+N)
  table.insert(config.keys, {
    key = "n",
    mods = "CTRL|CMD",
    action = wezterm.action_callback(switch_to_next_workspace_skip_scratch),
  })

  -- 前のワークスペースへ (Ctrl+Cmd+P)
  table.insert(config.keys, {
    key = "p",
    mods = "CTRL|CMD",
    action = wezterm.action_callback(switch_to_prev_workspace_skip_scratch),
  })

  -- ワークスペース選択（ファジー検索） (Leader+w)
  table.insert(config.keys, {
    key = "w",
    mods = "LEADER",
    action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" },
  })
end

function M.setup_events()
  -- 必要に応じてイベントハンドラーを追加
end

return M
