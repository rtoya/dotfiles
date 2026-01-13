{ config, pkgs, lib, username, homeDirectory, ... }:

let
  # ディレクトリ内のdefault.nixを自動インポート
  toolDirs = [ ./modules/wezterm ./modules/mise ./modules/nixvim ./modules/zsh ];
in

{
  imports = toolDirs;

  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    eza
    git
    mise
    tree
  ];

  # fonts (macOS)
  home.file."Library/Fonts/moralerspace" = {
    source = "${pkgs.moralerspace}/share/fonts/moralerspace";
    recursive = true;
  };

  # git
  programs.git = {
    enable = true;
    settings = {
      user.name = "rtoya";
      user.email = "mshbmmsmsm.u.yauya.da.yo.n@gmail.com";
    };
  };

  # gh (GitHub CLI)
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  # mise
  programs.mise.enable = true;

  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
