local wezterm = require 'wezterm'
local M = {}

function M.apply_to_config(config)
  config.status_update_interval = 1000
end

function M.setup_events()
  wezterm.on("update-status", function(window, pane)
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

    local left_status = wezterm.format({
      { Foreground = { Color = "#268bd2" } },
      { Text = "  " .. workspace .. " " },
      { Foreground = { Color = "#073642" } },
      { Text = "| " },
      { Foreground = { Color = "#b58900" } },
      { Text = "󱃾 " .. k8s_context .. " " },
    })
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
