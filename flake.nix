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
              autoconf
              automake
              bison
              boost
              git
              libevent
              libtool
              pkg-config
              protobuf
              python3
              zeromq
              db48
              openssl
              sqlite
              bear # compile_commands.json for various cpp language servers
            ] ++ lib.optional stdenv.isLinux [
              # linux-only dependencies
              libsystemtap # tracepoint support
            ];
          };
      }
    );
}
