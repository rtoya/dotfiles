{ config, pkgs, ... }:
let
  zenoDir = "${config.home.homeDirectory}/dotfiles/home/modules/zeno";

  zeno-zsh = pkgs.fetchFromGitHub {
    owner = "yuki-yano";
    repo = "zeno.zsh";
    rev = "f6ed8fc16cc32dc110fa4f77a50386624067fbe2";
    hash = "sha256-KmtmmGzWGBLslro3fkA0qx9YNV5lwlrgRzz7tiKSwvA=";
  };
in
{
  home.packages = [ pkgs.deno ];

  home.file.".local/share/zeno.zsh" = {
    source = zeno-zsh;
    recursive = true;
  };

  xdg.configFile = {
    "zeno/config.yml".source = config.lib.file.mkOutOfStoreSymlink "${zenoDir}/config.yml";
    "zeno/git.yml".source = config.lib.file.mkOutOfStoreSymlink "${zenoDir}/git.yml";
    "zeno/k8s.yml".source = config.lib.file.mkOutOfStoreSymlink "${zenoDir}/k8s.yml";
    "zeno/terraform.yml".source = config.lib.file.mkOutOfStoreSymlink "${zenoDir}/terraform.yml";
    "zeno/nix.yml".source = config.lib.file.mkOutOfStoreSymlink "${zenoDir}/nix.yml";
    "zeno/aws.yml".source = config.lib.file.mkOutOfStoreSymlink "${zenoDir}/aws.yml";
  };
}
