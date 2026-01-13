{ config, ... }:
{
  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/home/modules/wezterm/wezterm.lua";
}
