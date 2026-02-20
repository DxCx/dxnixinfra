{
  src,
  pkgs,
  extraChecks ? {},
}:
{
  format =
    pkgs.runCommand "format-check" {
      nativeBuildInputs = [pkgs.alejandra];
    } ''
      alejandra --check ${src} > $out 2>&1 || (cat $out && exit 1)
    '';

  lint =
    pkgs.runCommand "statix-check" {
      nativeBuildInputs = [pkgs.statix];
    } ''
      statix check ${src} > $out 2>&1 || (cat $out && exit 1)
    '';

  deadnix =
    pkgs.runCommand "deadnix-check" {
      nativeBuildInputs = [pkgs.deadnix];
    } ''
      deadnix --fail ${src} > $out 2>&1 || (cat $out && exit 1)
    '';
}
// extraChecks
