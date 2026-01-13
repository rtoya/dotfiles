{ config, pkgs, lib, ... }:

let
  cfg = config.programs.krew;
in
{
  options.programs.krew = {
    enable = lib.mkEnableOption "krew kubectl plugin manager";

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "flame" "neat" "tree" ];
      description = "List of krew plugins to install";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.krew ];

    # kubectl-krew symlink for kubectl plugin discovery
    home.file.".local/bin/kubectl-krew".source = "${pkgs.krew}/bin/krew";

    home.activation.installKrewPlugins = lib.mkIf (cfg.plugins != [ ]) (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export PATH="${pkgs.krew}/bin:''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
        for plugin in ${lib.concatStringsSep " " cfg.plugins}; do
          if ! kubectl krew list 2>/dev/null | grep -q "^$plugin$"; then
            $DRY_RUN_CMD kubectl krew install "$plugin" 2>/dev/null || true
          fi
        done
      ''
    );
  };
}
