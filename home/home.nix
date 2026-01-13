{ config, pkgs, username, homeDirectory, ... }:

{
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

  programs.starship.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };
}

