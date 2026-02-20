{
  description = "DxCx shared Nix infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }: let
    lib = import ./lib;
  in
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        lib.mkFlakeOutputs {
          src = ./.;
          inherit pkgs;
        }
    )
    // {
      inherit lib;
    };
}
