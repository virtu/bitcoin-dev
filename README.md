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
 - autoconf
 - automake
 - bison
 - boost
 - git
 - libevent
 - libtool
 - pkg-config
 - protobuf
 - python3
 - zeromq
 - db48
 - openssl
 - sqlite
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
- `a`: run automake
- `ac`: run automake and configure
- `acm`: run automake, configure and make (using nproc/2 jobs)
- `acmf`: run automake, configure and make fast (using nproc jobs)
- `c`: run configure
- `m`: run make (using nproc/2 jobs)
- `mf`: run make fast (using nproc jobs)
- `g`: clone/update repo: `g u` for upstream, `g f` (or simply `g`) for fork repo.
