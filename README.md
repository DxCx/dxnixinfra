# dxnixinfra

Shared Nix quality infrastructure for DxCx projects.

Provides consistent formatting, linting, and dead-code checks across all DxCx Nix flakes.

## What's Included

- **mkChecks** — `nix flake check` derivations for [alejandra](https://github.com/kamadorueda/alejandra) (formatting), [statix](https://github.com/nerdypepper/statix) (linting), and [deadnix](https://github.com/astro/deadnix) (dead code detection)
- **mkDevShell** — development shell with all three tools available
- **mkFlakeOutputs** — combines the above into ready-to-use flake outputs (`formatter`, `checks`, `devShells`)

## Integration

Add dxnixinfra as a flake input and use `mkFlakeOutputs` in your outputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    dxnixinfra = {
      url = "github:DxCx/dxnixinfra";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = {nixpkgs, flake-utils, dxnixinfra, ...}:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      {
        # your outputs here
        packages.default = ...;
      }
      // dxnixinfra.lib.mkFlakeOutputs {
        src = ./.;
        inherit pkgs;
      }
    );
}
```

This gives you:
- `nix fmt` — format all Nix files with alejandra
- `nix flake check` — runs format, lint, and deadnix checks
- `nix develop` — shell with alejandra, statix, and deadnix

### Custom Checks and Dev Packages

You can extend the defaults:

```nix
dxnixinfra.lib.mkFlakeOutputs {
  src = ./.;
  inherit pkgs;
  extraChecks = {
    myCheck = pkgs.runCommand "my-check" {} ''echo ok > $out'';
  };
  extraDevPackages = [pkgs.nil];
}
```
