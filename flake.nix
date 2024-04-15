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
        devShell = pkgs.mkShell.override
          {
            stdenv = pkgs.overrideCC pkgs.llvmPackages.libcxxStdenv # use llmv/clang
              (pkgs.llvmPackages.stdenv.cc.override {
                bintools = pkgs.llvmPackages.bintools; # use llvm linker
              });
          }
          {
            nativeBuildInputs = with pkgs; [
              clang-tools # clang wrapper (to guarantee view of headers in stdlib)
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
              libsystemtap # tracepoint support
              bear # compile_commands.json for cpp language servers
            ];
          };
      }
    );
}
