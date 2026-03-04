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

  users.users.ryotoya = {
    home = "/Users/ryotoya";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.primaryUser = "ryotoya";
  system.stateVersion = 5;
}
