{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell ({
  buildInputs = with pkgs; [
    haskell.compiler.ghc94
    cabal-install
    (haskell-language-server.override { supportedGhcVersions = [ "94" ]; })
    haskellPackages.cabal-fmt
    haskellPackages.fourmolu
    libz
  ];

  shellHook = ''
    echo "~Environment for Haskell is ready~"
  '';
})
