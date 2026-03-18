{
  description = "NixOS configuration for howard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    ngrok.url = "github:ngrok/ngrok-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ngrok }: {
    nixosConfigurations = {
      howard = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
        };
        modules = [
          ngrok.nixosModules.ngrok
          ./hosts/howard
        ];
      };
    };
  };
}
