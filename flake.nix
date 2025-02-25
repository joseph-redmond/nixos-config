{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, disko, ... }: {
    nixosConfigurations.hc001 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./system/hc001/configuration.nix
        ./system/hc001/disk-config.nix
      ];
    };

    nixosConfigurations.hc001-wordpress = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./system/hc001-wordpress/configuration.nix
        ./system/hc001-wordpress/disk-config.nix
      ];
    };
  };
}
