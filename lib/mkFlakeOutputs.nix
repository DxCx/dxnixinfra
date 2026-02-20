{
  src,
  pkgs,
  extraChecks ? {},
  extraDevPackages ? [],
}: let
  mkChecks = import ./mkChecks.nix;
  mkDevShell = import ./mkDevShell.nix;
in {
  formatter = pkgs.alejandra;
  checks = mkChecks {inherit src pkgs extraChecks;};
  devShells.default = mkDevShell {
    inherit pkgs;
    extraPackages = extraDevPackages;
  };
}
