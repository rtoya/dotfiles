local wezterm = require 'wezterm'
local M = {}

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
  -- タブタイトルフォーマット（Solarized Dark）
  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local background = "#073642"
    local foreground = "#586e75"
    if tab.is_active then
      background = "#268bd2"
      foreground = "#002b36"
    elseif hover then
      background = "#073642"
      foreground = "#93a1a1"
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
end

return M
