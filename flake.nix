{
  description = "NixOS systems and tools by nwjsmith";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";

      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # We have access to unstable nixpkgs if we want specific unstable packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs: let
    # Overlays is the list of overlays we want to apply from flake inputs.
    overlays = [
    ];
  in {
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem rec {
      system = "aarch64-linux";

      modules = [
        # Apply our overlays. Overlays are keyed by system type so we have
        # to go through and apply our system type. We do this first so
        # the overlays are available globally.
        { nixpkgs.overlays = overlays; }

        ./hardware/vm.nix
        ./machines/vm.nix
        ./users/nwjsmith/nixos.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nwjsmith = import ./users/nwjsmith/home-manager.nix;
        }
      ];
    };
  };
}
