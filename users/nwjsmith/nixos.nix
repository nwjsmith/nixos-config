{ pkgs, ... }:

{
  users.users.nwjsmith = {
    isNormalUser = true;
    home = "/home/nwjsmith";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    hashedPassword = "$6$G9Oz8GW5i5cEr4Si$oE7F/Gy5vb/DRdIlfQT1Uuo0z5KSkcY1R6311NzrWgbzLjUG4MbmUAS1//nEwEWvAuyN/41EF8h43vKXP4Fnl1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtWR1nXAvSmsd92TC9rMuZIh1Ec8cqxYr3BIyUxdNyy"
    ];
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [
  ];
}
