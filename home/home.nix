{ config, pkgs, lib, username, homeDirectory, ... }:

let
  moduleDir = ./modules;
  modules =
    builtins.attrValues (lib.mapAttrs (name: _: moduleDir + "/${name}")
      (lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name)
        (builtins.readDir moduleDir)));
in

{
  imports = modules;
  
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "24.05";
  
  home.packages = with pkgs; [
    eza
    gh
    git
    mise
    tree
  ];

  # fonts (macOS)
  home.file."Library/Fonts/moralerspace" = {
    source = "${pkgs.moralerspace}/share/fonts/moralerspace";
    recursive = true;
  };

  # zsh
  programs.zsh.enable = true;

  home.file.".zshrc.d".source = ./zshrc.d;
  home.file.".zshrc.d".recursive = true;

  programs.zsh.initContent = ''
    # Load split zsh configs
    if [ -d "$HOME/.zshrc.d" ]; then
      for f in "$HOME/.zshrc.d"/*.zsh; do
        [ -r "$f" ] && source "$f"
      done
    fi
  '';

  # git
  programs.git = {
    enable = true;

    settings = {
      user.name = "rtoya";
      user.email = "mshbmmsmsm.u.yauya.da.yo.n@gmail.com";
    };
  };

  # mise
  programs.mise.enable = true;

  programs.starship.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };
}

