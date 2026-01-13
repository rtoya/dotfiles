{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

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
    '';

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
  };
}
