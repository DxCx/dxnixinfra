{
  pkgs,
  extraPackages ? [],
}:
pkgs.mkShell {
  packages = [pkgs.alejandra pkgs.statix pkgs.deadnix pkgs.shellcheck pkgs.shfmt] ++ extraPackages;
  shellHook = ''
    echo "dxnixinfra dev shell"
    echo "  nix fmt        - format nix files"
    echo "  statix check . - lint nix files"
    echo "  deadnix .      - find dead code"
    echo "  shellcheck *.sh - lint shell scripts"
    echo "  shfmt -d *.sh  - check shell formatting"
  '';
}
