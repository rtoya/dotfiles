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
  datadog-mcp-cli = pkgs.stdenv.mkDerivation rec {
    pname = "datadog-mcp-cli";
    version = "latest";
    src = pkgs.fetchurl {
      url = "https://coterm.datadoghq.com/mcp-cli/datadog_mcp_cli-macos-arm64";
      sha256 = "sha256-7DtQTdJaQt7HFRaEpgbqIXlCS5DbiqHDSjfhL+1OoyE=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/datadog-mcp-cli
      chmod +x $out/bin/datadog-mcp-cli
    '';
  };
  gogcli = pkgs.stdenv.mkDerivation rec {
    pname = "gogcli";
    version = "0.11.0";
    src = pkgs.fetchurl {
      url = "https://github.com/steipete/gogcli/releases/download/v${version}/gogcli_${version}_darwin_arm64.tar.gz";
      sha256 = "sha256-ESaGjD+TmhSqlld9Vlj1/vHhU58zJzC/NaBudBYsnmE=";
    };
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/bin
      cp gog $out/bin/gog
      chmod +x $out/bin/gog
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
    ffmpeg
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
    nodejs
    peco
    tig
    tree
    xh
    yazi
    yq
    zellij
    gogcli
    datadog-mcp-cli
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

  # atuin (shell history)
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      show_numeric_shortcuts = false;
    };
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
