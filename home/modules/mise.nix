{ config, ... }:

{
  xdg.configFile."mise/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/developments/others/dotfiles/home/files/mise/config.toml";
}
