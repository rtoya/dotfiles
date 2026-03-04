{ pkgs, ... }:

{
  homebrew = {
    enable = true;
    casks = [
      "blackhole-2ch"
    ];
    onActivation = {
      cleanup = "none";
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = 5;
}
