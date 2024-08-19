# SPDX-FileCopyrightText: 2023 The Watchers Developers
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    esp-dev-rust = {
      url = "github:shymega/esp32-dev.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { ... }@inputs:
    let
      system = "x86_64-linux";
      overlays = [
        inputs.fenix.overlays.default
        inputs.esp-dev-rust.overlays.default
      ];

      pkgs = import inputs.nixpkgs {
        inherit system overlays;
      };
      rustToolchain = with inputs.fenix.packages.${system}; combine [
        pkgs.rust-esp
        pkgs.rust-src-esp
      ];
    in
    {
      inherit (inputs) self;
      inherit pkgs;

      devShells.${system}.default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          cargo-binutils
          cargo-espflash
          cargo-espmonitor
          cargo-leptos
          cargo-sort
          clang
          esp-idf-esp32
          espflash
          git
          gnumake
          just
          ldproxy
          llvmPackages_17.bintools
          pkg-config
          platformio
          probe-rs
          rustToolchain
          rustup
          wget
        ];
        shellHook = ''
          unset IDF_PATH
          unset IDF_TOOLS_PATH
          unset IDF_PYTHON_CHECK_CONSTRAINTS
          unset IDF_PYTHON_ENV_PATH
          export PLATFORMIO_CORE_DIR=$PWD/.platformio
        '';
      };
    };
}
