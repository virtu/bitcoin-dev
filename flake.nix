{
  description = "Development environment for Bitcoin Core";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; }
          {
            nativeBuildInputs = with pkgs; [
              clang-tools # correctly-wrapped clangd as cpp language server
            ];
            buildInputs = with pkgs; [
              cmake
              pkg-config
              python3
              libevent
              boost
              sqlite # descriptor wallet
              zeromq # zmq
              git
              bear # compile_commands.json for various cpp language servers
            ] ++ lib.optional stdenv.isLinux [
              # linux-only dependencies
              libsystemtap # tracepoint support
              bpftrace # required by tracepoint scripts in `contrib/tracing`
              bcc # required by functional tests for tracepoints
            ];
            shellHook = with pkgs; lib.optionalString stdenv.isLinux ''
              echo "Run export PYTHONPATH=$PYTHONPATH:${pkgs.bcc}/lib/python3.11/site-packages/bcc-0.29.1-py3.11.egg to run functional tests."
            '';
          };
      }
    );
}
