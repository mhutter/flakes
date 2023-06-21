{
  description = "Personal collection of Nix Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        cloudscale = import ./pkg/cloudscale.nix { inherit pkgs; };
      in
      {
        packages = {
          cloudscale-cli = cloudscale.cli;
          cloudscale-sdk = cloudscale.sdk;
        };
      }
    );
}
