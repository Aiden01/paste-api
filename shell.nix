
let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
in stdenv.mkDerivation {
  name = "HaskordEnv";
  buildInputs = with pkgs; [
    ghc
    cabal-install
    haskellPackages.ghcid
    gcc
    zlib.dev
  ];
  shellHook = ''
   alias repl="ghcid --command=cabal v2-repl"
  '';
  LD_LIBRARY_PATH="${pkgs.zlib}/lib";
}
