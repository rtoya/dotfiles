{ config, ... }:
let
  weztermDir = "${config.home.homeDirectory}/dotfiles/home/modules/wezterm";
in
{
  xdg.configFile = {
    "wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${weztermDir}/wezterm.lua";
    "wezterm/appearance.lua".source = config.lib.file.mkOutOfStoreSymlink "${weztermDir}/appearance.lua";
    "wezterm/keymaps.lua".source = config.lib.file.mkOutOfStoreSymlink "${weztermDir}/keymaps.lua";
    "wezterm/statusbar.lua".source = config.lib.file.mkOutOfStoreSymlink "${weztermDir}/statusbar.lua";
    "wezterm/tab.lua".source = config.lib.file.mkOutOfStoreSymlink "${weztermDir}/tab.lua";
    "wezterm/utils.lua".source = config.lib.file.mkOutOfStoreSymlink "${weztermDir}/utils.lua";
    "wezterm/workspace.lua".source = config.lib.file.mkOutOfStoreSymlink "${weztermDir}/workspace.lua";
    "wezterm/opacity.lua".source = config.lib.file.mkOutOfStoreSymlink "${weztermDir}/opacity.lua";
  };
}
