local wezterm = require 'wezterm'
local M = {}

function M.apply_to_config(config)
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

  -- GitHubのissue/PR参照
  table.insert(config.hyperlink_rules, {
    regex = [[\b([A-Za-z0-9_-]+/[A-Za-z0-9_-]+)#(\d+)\b]],
    format = "https://github.com/$1/issues/$2",
  })

  -- ============================================
  -- その他
  -- ============================================
  config.scrollback_lines = 10000
  config.enable_scroll_bar = true
  config.check_for_updates = false
end

function M.setup_events()
  -- ベル発生時に通知
  wezterm.on("bell", function(window, pane)
    window:toast_notification("Wezterm", "Bell in " .. pane:get_title(), nil, 4000)
  end)
end

return M
