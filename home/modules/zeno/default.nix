{ config, pkgs, ... }:
let
  zenoDir = "${config.home.homeDirectory}/dotfiles/home/modules/zeno";

  zeno-zsh = pkgs.fetchFromGitHub {
    owner = "yuki-yano";
    repo = "zeno.zsh";
    rev = "main";
    sha256 = "0k7nkh3lqy4xw71x6nlw9vqyasjb4b9bhdghdl1xlh1aj9yy3h7s";
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
    "zeno/jj.yml".source = config.lib.file.mkOutOfStoreSymlink "${zenoDir}/jj.yml";
  };
}
