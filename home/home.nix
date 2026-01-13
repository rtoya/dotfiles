{ config, pkgs, username, homeDirectory, ... }:

{
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    git
    gh
    eza
  ];

  programs.zsh.enable = true;

  programs.git = {
    enable = true;
    user.name = "rtoya";
    user.email = "mshbmmsmsm.u.yauya.da.yo.n@gmail.com";
  };

  programs.starship.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };
}

