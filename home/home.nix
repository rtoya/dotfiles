{ config, pkgs, lib, username, homeDirectory, ... }:

let
  # ディレクトリ内のdefault.nixを自動インポート
  toolDirs = [ ./modules/wezterm ./modules/mise ./modules/nixvim ./modules/zsh ./modules/krew ];
in

{
  imports = toolDirs;

  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    awscli2
    chezmoi
    eza
    gat
    git
    kubectl
    kustomize
    mise
    tree
    xh
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

  # krew
  programs.krew = {
    enable = true;
    plugins = [
      "ctx"
      "datadog"
      "get-all"
      "iexec"
      "neat"
      "node-shell"
      "ns"
      "open-svc"
      "resource-capacity"
      "rolesum"
      "score"
      "sniff"
      "status"
      "stern"
      "tail"
      "tree"
      "view-utilization"
    ];
  };
}
