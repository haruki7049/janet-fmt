{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    buildJanetPackage = {
      url = "github:haruki7049/buildJanetPackage";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      imports = [
        inputs.treefmt-nix.flakeModule
      ];
      perSystem =
        { pkgs, ... }:
        let
          janet-fmt = pkgs.callPackage ./. { buildJanetPackage-source = inputs.buildJanetPackage; };
        in
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.shellcheck.enable = true;
            programs.actionlint.enable = true;

            settings.formatter.shellcheck.excludes = [
              ".envrc"
            ];
          };

          checks = {
            inherit janet-fmt;
          };

          packages = {
            inherit janet-fmt;
            default = janet-fmt;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              # Nix
              pkgs.nil

              # Janet
              pkgs.janet
              pkgs.jpm
            ];
          };
        };
    };
}
