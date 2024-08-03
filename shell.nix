{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell ({
  buildInputs = with pkgs; [
    haskell.compiler.ghc981
    cabal-install
    (haskell-language-server.override { supportedGhcVersions = [ "98" ]; })
    haskellPackages.cabal-fmt
    haskellPackages.fourmolu
    libz
  ];

  shellHook = ''
    echo "~Environment for Haskell is ready~"
  '';
})
