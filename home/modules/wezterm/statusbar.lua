local wezterm = require 'wezterm'
local M = {}

-- ============================================
-- カーソル色定義（モード別）
-- ============================================
local CURSOR_COLORS = {
  default = "#80EBDF",      -- シアン（通常時）
  copy_mode = "#ffd700",    -- ゴールド（コピーモード）
  setting_mode = "#39FF14", -- ネオングリーン（設定モード）
}

local last_cursor_color = nil

function M.apply_to_config(config)
  config.status_update_interval = 1000
end

function M.setup_events()
  wezterm.on("update-status", function(window, pane)
    -- ============================================
    -- 動的カーソル色変更
    -- ============================================
    local key_table = window:active_key_table()
    local cursor_color = CURSOR_COLORS[key_table] or CURSOR_COLORS.default
    if last_cursor_color ~= cursor_color then
      last_cursor_color = cursor_color
      pane:inject_output("\x1b]12;" .. cursor_color .. "\x1b\\")
    end

    -- 左側: ワークスペース名 + Kubernetesコンテキスト
    local workspace = window:active_workspace()

    -- kubeconfigから現在のコンテキストを取得
    local k8s_context = ""
    local home = os.getenv("HOME") or ""
    local kubeconfig_path = home .. "/.kube/config"
    local f = io.open(kubeconfig_path, "r")
    if f then
      local content = f:read("*all")
      f:close()
      -- current-context: の行を探す
      local context = content:match("current%-context:%s*([^\n]+)")
      if context then
        -- ARNの場合はクラスター名だけ抽出
        local cluster_name = context:match(":cluster/([^%s]+)") or context
        k8s_context = cluster_name
      end
    end

    -- モード名の表示テキスト
    local mode_text = ""
    if key_table then
      local mode_labels = {
        copy_mode = "COPY",
        setting_mode = "SETTING",
        search_mode = "SEARCH",
      }
      mode_text = mode_labels[key_table] or key_table:upper()
    end

    local left_status_elements = {
      { Foreground = { Color = "#268bd2" } },
      { Text = "  " .. workspace .. " " },
    }

    -- モードがアクティブな場合は表示
    if mode_text ~= "" then
      table.insert(left_status_elements, { Foreground = { Color = "#073642" } })
      table.insert(left_status_elements, { Text = "| " })
      table.insert(left_status_elements, { Foreground = { Color = cursor_color } })
      table.insert(left_status_elements, { Text = " " .. mode_text .. " " })
    end

    table.insert(left_status_elements, { Foreground = { Color = "#073642" } })
    table.insert(left_status_elements, { Text = "| " })
    table.insert(left_status_elements, { Foreground = { Color = "#b58900" } })
    table.insert(left_status_elements, { Text = "󱃾 " .. k8s_context .. " " })

    local left_status = wezterm.format(left_status_elements)
    window:set_left_status(left_status)

    -- 右側: CWD + Gitブランチ + 時刻
    local cwd = pane:get_current_working_dir()
    local cwd_str = ""
    local cwd_path = ""
    if cwd then
      cwd_path = cwd.file_path or ""
      cwd_str = cwd_path
      -- ホームディレクトリを ~ に置換
      local home = os.getenv("HOME")
      if home and cwd_str:sub(1, #home) == home then
        cwd_str = "~" .. cwd_str:sub(#home + 1)
      end
    end

    -- Gitブランチ取得
    local git_branch = ""
    if cwd_path ~= "" then
      local handle = io.popen("cd " .. wezterm.shell_quote_arg(cwd_path) .. " && git rev-parse --abbrev-ref HEAD 2>/dev/null")
      if handle then
        local result = handle:read("*a")
        handle:close()
        if result and result ~= "" then
          git_branch = result:gsub("%s+$", "") -- 末尾の空白を除去
        end
      end
    end

    local time = wezterm.strftime("%H:%M")
    local date = wezterm.strftime("%m/%d")

    local right_status_elements = {
      { Foreground = { Color = "#586e75" } },
      { Text = " " .. cwd_str .. " " },
    }

    -- Gitブランチがあれば追加
    if git_branch ~= "" then
      table.insert(right_status_elements, { Foreground = { Color = "#073642" } })
      table.insert(right_status_elements, { Text = "" })
      table.insert(right_status_elements, { Foreground = { Color = "#6c71c4" } })
      table.insert(right_status_elements, { Text = "  " .. git_branch .. " " })
    end

    table.insert(right_status_elements, { Foreground = { Color = "#073642" } })
    table.insert(right_status_elements, { Text = "| " })
    table.insert(right_status_elements, { Foreground = { Color = "#859900" } })
    table.insert(right_status_elements, { Text = " " .. date .. " " })
    table.insert(right_status_elements, { Foreground = { Color = "#268bd2" } })
    table.insert(right_status_elements, { Text = " " .. time .. " " })

    local right_status = wezterm.format(right_status_elements)
    window:set_right_status(right_status)
  end)
end

return M
