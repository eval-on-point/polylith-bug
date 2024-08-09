{
  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv/v1.0.1";
  };

  outputs =
    inputs@{
      flake-parts,
      devenv,
      nixpkgs,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ devenv.flakeModule ];
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        { pkgs, ... }:
        {
          devenv.shells.default = {
            packages = with pkgs; [
              (clojure.overrideAttrs (previousAttrs: {
                version = "1.11.4.1474";
                src = fetchurl {
                  url = previousAttrs.src.url;
                  hash = "sha256-sNFDXvrHMrFgLrBHmbv3DKOXuNu6u1OqcmlqZNX/EAg=";
                };
              }))
            ];
          };
        };
    };
}
