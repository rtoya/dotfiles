{ pkgs, ... }:

{
  homebrew = {
    enable = true;
    casks = [
      "blackhole-2ch"
      "keycastr"
    ];
    onActivation = {
      cleanup = "none";
    };
  };

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

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
