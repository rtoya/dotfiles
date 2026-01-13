{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    # 基本設定
    opts = {
      number = true;
      relativenumber = true;
      clipboard = "unnamedplus";
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
    };

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
