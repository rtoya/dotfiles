{ config, ... }:

{
  # gh-dashの設定ファイル
  xdg.configFile."gh-dash/config.yml".source = ./config.yml;
}
