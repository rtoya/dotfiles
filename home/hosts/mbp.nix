{ config, pkgs, ... }:

{
  programs.zsh.shellAliases = {
    ls = "eza";
    ll = "eza -la";
  };
}
