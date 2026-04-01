{
  description = "city-builder";
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
          buildInputs = [
            alsa-lib.dev
            libllvm
            rust-bin.stable.latest.default
            llvmPackages.libcxxClang
            llvmPackages.bintools-unwrapped
            systemdLibs
            systemd
            # graphics deps for bevy
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
            libxkbcommon
            vulkan-loader
            wayland
            udev
          ];
          packages = [
            rust-analyzer
            rustfmt
            pkg-config
            systemdLibs
            systemd
          ];
          LD_LIBRARY_PATH = lib.makeLibraryPath [
            systemdLibs
            alsa-lib
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
            libxkbcommon
            vulkan-loader
            wayland
            udev
          ];
        };
      }
    );
}
