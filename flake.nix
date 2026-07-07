{
  description = "NixOS configuration for howard";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    lazyvim.url = "github:pfassina/lazyvim-nix";
    devenv.url = "github:cachix/devenv/9e5c17caf0ead1bb29d430d4c0a26a77bc5d374b";
  };

  outputs = { self, nixpkgs, lazyvim, devenv, ... }@inputs: {
    nixosConfigurations = {
      howard = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
        inherit inputs;
        };
        modules = [
          ./hosts/howard
        ];
      };
    };
  };
}
