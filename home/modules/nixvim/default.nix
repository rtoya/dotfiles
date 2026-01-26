{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    # Leaderキーをスペースに設定
    globals.mapleader = " ";

    # 基本設定
    opts = {
      number = true;
      relativenumber = false;
      clipboard = "unnamedplus";
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      termguicolors = true;
      signcolumn = "yes";  # サイン列を常に表示してずれを防ぐ
      numberwidth = 4;     # 行番号の幅を固定
    };

    # 背景透過（Weztermの透過設定を引き継ぐ）
    extraConfigLua = ''
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

      -- URL または AWS ARN を開く関数
      local function open_url_or_arn()
        local cword = vim.fn.expand("<cWORD>")
        local cfile = vim.fn.expand("<cfile>")
        local arn = cword:match("[\"'\`]?(arn:aws[a-z%-]*:[^\"'\`%%s]+)[\"'\`]?")
        if arn then
          vim.ui.open("https://console.aws.amazon.com/go/view?arn=" .. arn)
        else
          vim.ui.open(cfile)
        end
      end

      -- gx: URL または AWS ARN を開く
      vim.keymap.set("n", "gx", open_url_or_arn, { desc = "Open URL or AWS ARN" })

      -- Ctrl+クリック: URL または AWS ARN を開く
      vim.keymap.set("n", "<C-LeftMouse>", function()
        vim.cmd("normal! <LeftMouse>")  -- まずカーソルを移動
        open_url_or_arn()
      end, { desc = "Open URL or AWS ARN (click)" })
    '';

    # web-devicons（アイコン表示）
    plugins.web-devicons.enable = true;

    # treesitter
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        ensure_installed = [ "nix" "lua" "bash" "json" "yaml" "toml" "markdown" ];
      };
    };

    # LSP
    plugins.lsp = {
      enable = true;
      servers = {
        lua_ls.enable = true;
        nil_ls.enable = true;
      };
    };

    # 補完
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };

    # octo（GitHub連携）
    plugins.octo = {
      enable = true;
    };

    # diffview（Git差分表示）
    plugins.diffview = {
      enable = true;
    };

    # telescope（ファジーファインダー）
    plugins.telescope = {
      enable = true;
      settings = {
        defaults = {
          layout_config = {
            width = 0.75;
          };
          file_ignore_patterns = [ "^.git/" "vendor" ];
          vimgrep_arguments = [
            "${pkgs.ripgrep}/bin/rg"
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--smart-case"
            "--hidden"
          ];
        };
        pickers = {
          find_files = {
            hidden = true;
          };
        };
      };
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options.desc = "Find files";
        };
        "<leader>fg" = {
          action = "live_grep";
          options.desc = "Live grep";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "Buffers";
        };
        "<leader>fh" = {
          action = "help_tags";
          options.desc = "Help tags";
        };
      };
      extensions = {
        fzf-native.enable = true;
      };
    };

    # ripgrepとfdをtelescope用に追加
    extraPackages = with pkgs; [
      ripgrep
      fd
    ];
  };
}
