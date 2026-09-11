{
  description = "rust compiler";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShellNoCC {
          packages = [
            pkgs.git
            pkgs.clang-tools
            pkgs.clang
            pkgs.llvmPackages.bintools
            pkgs.gnumake
            pkgs.bison
            pkgs.flex
            pkgs.perl
            pkgs.bc
            pkgs.openssl
            pkgs.rsync
            pkgs.gmp
            pkgs.libmpc
            pkgs.mpfr
            pkgs.elfutils
            pkgs.zstd
            pkgs.python3
            pkgs.kmod
            pkgs.hexdump
            pkgs.cpio
            pkgs.pahole
            pkgs.zlib
            pkgs.rustc-unwrapped
            pkgs.rust-bindgen-unwrapped
            pkgs.pkg-config
          ];
          buildInputs = [
            pkgs.ncurses
          ];
          env = {
            RUST_LIB_SRC = pkgs.rustPlatform.rustLibSrc;

            # avoid leaking Rust source file names into the final binary, which adds
            # a false dependency on rust-lib-src on targets with uncompressed kernels
            KRUSTFLAGS = "--remap-path-prefix ${pkgs.rustPlatform.rustLibSrc}=/";
            NIX_CFLAGS_COMPILE = "-Wno-error=unused-command-line-argument";

            NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING = 1;
          };
        };
      }
    );
}
