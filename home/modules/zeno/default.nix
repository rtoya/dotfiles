{ config, pkgs, ... }:
let
  zenoDir = "${config.home.homeDirectory}/dotfiles/home/modules/zeno";

  zeno-zsh = pkgs.fetchFromGitHub {
    owner = "yuki-yano";
    repo = "zeno.zsh";
    rev = "82bb15e6410095883f28d92025a61937fa80aa09";
    hash = "sha256-+sDhfZIqQNoDbfA1uNIiS2rl8U6cWtPD4Z14TAec9kw=";
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
