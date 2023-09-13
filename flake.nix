{
  description = "Personal collection of Nix Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        go-packages = import ./pkg/go-packages.nix { inherit pkgs; };
        python-packages = import ./pkg/python-packages.nix { inherit pkgs; };

      in
      {
        packages = {
          inherit (go-packages)
            flyctl
            ;

          inherit (python-packages)
            cloudscale-cli
            cloudscale-sdk
            ;
        };
      }
    );
}
