# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

dxnixinfra is a shared Nix quality infrastructure library for DxCx projects. It is **not a standalone application** — it's a Nix flake input consumed by other projects to provide consistent formatting, linting, and dead-code checks.

## Common Commands

```bash
nix flake check --show-trace   # Run all quality checks (alejandra, statix, deadnix)
nix fmt                        # Format all Nix files with alejandra
nix develop                    # Enter dev shell with alejandra, statix, deadnix available
statix check .                 # Run linter directly
deadnix .                      # Run dead-code detection directly
```

## Architecture

The library exposes a single main entry point via `lib.mkFlakeOutputs`, which orchestrates two lower-level modules:

- **`lib/mkFlakeOutputs.nix`** — Public API. Takes `{ src, pkgs, extraChecks?, extraDevPackages? }` and returns `{ formatter, checks, devShells }`. Consuming flakes call this to get all quality infrastructure at once.
- **`lib/mkChecks.nix`** — Creates `nix flake check` derivations for alejandra (formatting), statix (linting), and deadnix (dead code). Each check runs against the provided `src`.
- **`lib/mkDevShell.nix`** — Creates a development shell with all three tools. Accepts `extraPackages` for extension.
- **`lib/default.nix`** — Auto-loader that imports all `.nix` files in `lib/` as attributes.

The flake itself uses `mkFlakeOutputs` on its own source (self-hosting pattern), so `nix flake check` validates this repo with the same infrastructure it provides to consumers.

## Nix Conventions

- Formatter: **alejandra** (not nixfmt or nixpkgs-fmt)
- Indentation: 2 spaces for all Nix, YAML, and JSON files (see `.editorconfig`)
- Flake inputs: `nixpkgs` (unstable) and `flake-utils`
