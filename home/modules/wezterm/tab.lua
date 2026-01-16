local wezterm = require 'wezterm'
local M = {}

-- ============================================
-- アイコン・色定義（Nerd Font）
-- ============================================
local ICONS = {
  ssh = "",      -- nf-dev-terminal_badge
  docker = "",   -- nf-linux-docker
  nvim = "",     -- nf-custom-neovim
  default = "",  -- nf-oct-terminal
  zoom = "",     -- nf-md-magnify
  claude = "",   -- nf-md-robot
}

local COLORS = {
  ssh = "#dc322f",      -- Solarized red
  docker = "#2496ED",   -- Docker blue
  nvim = "#57A143",     -- Neovim green
  claude = "#D97706",   -- Claude orange
  default = "#268bd2",  -- Solarized blue
}

-- ============================================
-- プロセス検出関数
-- ============================================

-- SSH接続中かどうかを判定
local function is_ssh_process(pane)
  local process_name = pane.foreground_process_name or ""
  local title = pane.title or ""

  -- プロセス名で判定
  if process_name:match("ssh$") or process_name:match("ssh%.exe$") then
    return true
  end

  -- タイトルで判定
  if title:match("^ssh ") or title:match("SSH:") then
    return true
  end

  return false
end

-- Dockerプロセスかどうかを判定
local function is_docker_process(pane)
  local process_name = pane.foreground_process_name or ""
  local title = pane.title or ""

  if process_name:match("docker") then
    return true
  end

  if title:match("docker") then
    return true
  end

  return false
end

-- Neovimプロセスかどうかを判定
local function is_nvim_process(pane)
  local process_name = pane.foreground_process_name or ""
  local title = pane.title or ""

  -- basenameを取得
  local basename = process_name:match("([^/\\]+)$") or ""

  if basename == "nvim" or basename == "vim" then
    return true
  end

  if title:match("^nvim") or title:match("^vim") then
    return true
  end

  return false
end

-- Claudeプロセスかどうかを判定
local function is_claude_process(pane)
  local process_name = pane.foreground_process_name or ""
  local title = pane.title or ""

  if process_name:match("claude") then
    return true
  end

  -- タイトルが"✳"で始まる場合もClaude
  if title:match("^claude") or title:match("^✳") then
    return true
  end

  return false
end

-- プロセスに応じたアイコンと色を取得
local function get_icon_and_color(pane)
  if is_ssh_process(pane) then
    return ICONS.ssh, COLORS.ssh
  elseif is_nvim_process(pane) then
    return ICONS.nvim, COLORS.nvim
  elseif is_claude_process(pane) then
    return ICONS.claude, COLORS.claude
  elseif is_docker_process(pane) then
    return ICONS.docker, COLORS.docker
  else
    return ICONS.default, COLORS.default
  end
end

-- ============================================
-- ズーム検出関数
-- ============================================

-- タブ内にズームされたペインがあるかどうかを判定
local function has_zoomed_pane(panes)
  for _, pane in ipairs(panes) do
    if pane.is_zoomed then
      return true
    end
  end
  return false
end

function M.apply_to_config(config)
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

  -- タブバーの色設定（Solarized Dark）
  config.colors = config.colors or {}
  config.colors.tab_bar = {
    background = "#002b36",
    inactive_tab_edge = "none",
    active_tab = {
      bg_color = "#268bd2",
      fg_color = "#002b36",
    },
    inactive_tab = {
      bg_color = "#073642",
      fg_color = "#586e75",
    },
    inactive_tab_hover = {
      bg_color = "#073642",
      fg_color = "#93a1a1",
    },
    new_tab = {
      bg_color = "#002b36",
      fg_color = "#268bd2",
    },
    new_tab_hover = {
      bg_color = "#073642",
      fg_color = "#93a1a1",
    },
  }
end

function M.setup_events()
  -- タブタイトルフォーマット
  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local active_pane = tab.active_pane

    -- プロセスに応じたアイコンと色を取得
    local icon, icon_color = get_icon_and_color(active_pane)

    -- ズームインジケーター
    local zoom_indicator = ""
    if has_zoomed_pane(tab.panes) then
      zoom_indicator = ICONS.zoom .. " "
    end

    -- タブの背景色・前景色を決定
    local background = "#073642"
    local foreground = "#586e75"
    if tab.is_active then
      -- SSH接続時は赤背景
      if is_ssh_process(active_pane) then
        background = COLORS.ssh
      else
        background = "#268bd2"
      end
      foreground = "#002b36"
    elseif hover then
      background = "#073642"
      foreground = "#93a1a1"
    end

    -- タイトルを取得
    local title = active_pane.title or ""
    local index = tab.tab_index + 1

    -- タブタイトルを構築
    local tab_title = zoom_indicator .. icon .. " " .. index .. ": " .. title

    -- 長すぎる場合は切り詰め
    if #tab_title > max_width - 2 then
      tab_title = wezterm.truncate_right(tab_title, max_width - 2)
    end

    return {
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = " " .. tab_title .. " " },
    }
  end)
end

return M
