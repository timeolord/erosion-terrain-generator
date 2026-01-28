{
  description = "music-generator";
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          # strictDeps = true;
          buildInputs = [
            alsa-lib.dev
            # alsa-lib
            libllvm
            rust-bin.stable.latest.default
            # clang
            llvmPackages.libcxxClang
            llvmPackages.bintools-unwrapped
            systemdLibs
            systemd
          ];
          packages = [
            # cargo
            # rustc
            # rustPlatform.bindgenHook
            rust-analyzer
            rustfmt
            pkg-config
            systemdLibs
            systemd
            # libclang
            # llvm.lld
            # llvm.clang-tools
            # llvmPackages.bintools
          ];
        };
      }
    );
}
