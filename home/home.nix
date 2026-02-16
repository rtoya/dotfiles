{ config, pkgs, lib, username, homeDirectory, ... }:

let
  gh-aw = pkgs.stdenv.mkDerivation rec {
    pname = "gh-aw";
    version = "0.45.0";
    src = pkgs.fetchurl {
      url = "https://github.com/github/gh-aw/releases/download/v${version}/darwin-arm64";
      sha256 = "sha256-ftP+aClD91LS7weQYvRV/+6bA43lStbpWNwEQMWNfkk=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/gh-aw
      chmod +x $out/bin/gh-aw
    '';
  };
  # ディレクトリ内のdefault.nixを自動インポート
  toolDirs = [ ./modules/wezterm ./modules/mise ./modules/nixvim ./modules/zsh ./modules/krew ./modules/zeno ./modules/direnv ./modules/gh-dash ];
in

{
  imports = toolDirs;

  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    awscli2
    bat
    chezmoi
    eza
    gat
    ghq
    gibo
    git
    google-cloud-sdk
    kubecolor
    kubectl
    kubeseal
    kustomize
    mise
    peco
    tig
    tree
    xh
    yazi
    yq
    zellij
  ];

  # fonts (macOS)
  home.file."Library/Fonts/moralerspace" = {
    source = "${pkgs.moralerspace}/share/fonts/moralerspace";
    recursive = true;
  };
  home.file."Library/Fonts/hackgen-nf" = {
    source = "${pkgs.hackgen-nf-font}/share/fonts/hackgen-nf";
    recursive = true;
  };

  # git
  programs.git = {
    enable = true;
    settings = {
      user.name = "rtoya";
      user.email = "mshbmmsmsm.u.yauya.da.yo.n@gmail.com";
      ghq.root = "~/development";
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user.name = "rtoya";
      user.email = "mshbmmsmsm.u.yauya.da.yo.n@gmail.com";
      ui = {
        default-command = "log";
        pager = "less -FRX";
      };
      aliases = {
        l = ["log" "-r" "(main..@):: | (main..@)-"];
      };
    };
  };

  # gh (GitHub CLI)
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    extensions = [ pkgs.gh-dash gh-aw ];
  };

  # mise
  programs.mise.enable = true;

  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # zoxide (smarter cd)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    # options = [ "--cmd" "cd" ];  # cdコマンドをzoxideに置き換え
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
