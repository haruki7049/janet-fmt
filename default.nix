{
  pkgs ? import <nixpkgs> { },
  buildJanetPackage-source ? builtins.fetchTarball {
    url = "https://github.com/haruki7049/buildJanetPackage/archive/420fb441d7e57c4ee8cd1ecd575ab3032d27f7cc.tar.gz";
    sha256 = "0cl8496jafi9h39y7zk5cda82g7mz0dd703i0h7dzg2gvxd945jf";
  },
}:

let
  janetBuilder = import buildJanetPackage-source { inherit pkgs; };
  lib = pkgs.lib;
in
janetBuilder.buildJanetPackage {
  pname = "deps-parser";
  version = "0.1.0";
  src = lib.cleanSource ./.;
  depsFile = ./deps.nix;

  executableFiles = [ "janet-fmt" ];
}
