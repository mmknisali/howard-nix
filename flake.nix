{
  description = "NixOS configuration for howard";
  
  nixConfig = {
    extra-substituters = [ "https://playit-nixos-module.cachix.org" ];
    extra-trusted-public-keys = [ "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4=" ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    lazyvim.url = "github:pfassina/lazyvim-nix";
    devenv.url = "github:cachix/devenv/9e5c17caf0ead1bb29d430d4c0a26a77bc5d374b";
    playit-nixos-module.url = "github:pedorich-n/playit-nixos-module";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, lazyvim, devenv, playit-nixos-module, ... }@inputs: {
    nixosConfigurations = {
      howard = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
        inherit inputs;
        };
        modules = [
          ./hosts/howard
          playit-nixos-module.nixosModules.default
          inputs.disko.nixosModules.disko
          ./disko.nix
        ];
      };
    };
  };
}
