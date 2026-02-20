{
  pkgs,
  extraPackages ? [],
}:
pkgs.mkShell {
  packages = [pkgs.alejandra pkgs.statix pkgs.deadnix] ++ extraPackages;
  shellHook = ''
    echo "dxnixinfra dev shell"
    echo "  nix fmt        - format nix files"
    echo "  statix check . - lint nix files"
    echo "  deadnix .      - find dead code"
  '';
}
