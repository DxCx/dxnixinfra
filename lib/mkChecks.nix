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

  shellcheck =
    pkgs.runCommand "shellcheck-check" {
      nativeBuildInputs = [pkgs.shellcheck pkgs.findutils];
    } ''
      SCRIPTS=$(find ${src} -name '*.sh' -type f)
      if [ -n "$SCRIPTS" ]; then
        echo "$SCRIPTS" | xargs shellcheck
      fi
      touch $out
    '';

  shfmt =
    pkgs.runCommand "shfmt-check" {
      nativeBuildInputs = [pkgs.shfmt pkgs.findutils];
    } ''
      SCRIPTS=$(find ${src} -name '*.sh' -type f)
      if [ -n "$SCRIPTS" ]; then
        echo "$SCRIPTS" | xargs shfmt -d -i 2 -ci
      fi
      touch $out
    '';
}
// extraChecks
