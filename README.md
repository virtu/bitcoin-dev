# Development environment for Bitcoin Core

This repository provides a reproducible development environment for Bitcoin Core.

Reproducibility is provided via a [Nix flake](#nix-flake).

The [flake](#nix-flake) and several [convenience scripts](#convenience-scripts) can be
loaded automatically via [direnv](#direnv).

## Installation

- Install the [nix package manager](https://nixos.org/download/) or
  [NixOS](https://nixos.org/download/)
- To set up the development environment manually, run `nix develop` in the repository
- To set everything up automatically, install [direnv](https://github.com/direnv/direnv)
  and run `direnv allow .`

## Components

### Nix flake

The nix flake provides a development shell (via an `devShell` output) for all architecture's
covered by Nix's `eachDefaultSystem` function.

The flake uses `llvm`/`clang` to compile the code, and includes the following Bitcoin Core
dependencies:
 - cmake
 - pkg-config
 - python3
 - libevent
 - boost
 - sqlite
 - git
 - libsystemtap (for tracepoint support)

The flake also includes the following non-Bitcoin Core dependencies:
- bear (for creation of compiler-generated meta data used by C++ language servers such
  as [clangd](https://github.com/clangd/clangd) and [ccls](https://github.com/MaskRay/ccls))

### Direnv

When granted permission (via `direnv allow .`), the `.envrc` included in the repo file
instructs [direnv](https://github.com/direnv/direnv) to automatically:
1. Load the nix flake
2. Add the [convenience scripts](#convenience-scripts) in `scripts/` to the shell's `PATH`

### Convenience Scripts

Shell scripts are used for convenience instead of defining `alias`es via the flake's
`shellHooks` target, as the latter approach does not work for non-bash shell.

The `scripts` directory can be added to the current shell's `PATH` variable via
[direnv](https://github.com/direnv/direnv).

Current scripts:
- `c`: run configure
- `m`: run cmake (using nproc/2 jobs)
- `cm`: configure and cmake (using nproc/2 jobs)
- `mf`: run cmake fast (using nproc jobs)
- `acmf`: configure and cmake fast (using nproc jobs)
- `g`: clone/update repo: `g u` for upstream, `g f` (or simply `g`) for fork repo.
- `bitcoind` and `bitcoin-cli`: wrappers to run binaries in `src/` after building,
  ensuring custom datadir, P2P and RPC ports, and enabling pruning (5GB).
- `get-pr`: convenience script for checking our pull requests
