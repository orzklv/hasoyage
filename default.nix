{ pkgs ? import <nixpkgs> { } }:

pkgs.haskellPackages.developPackage {
  root = ./.;
  modifier = drv:
    pkgs.haskell.lib.addBuildTools drv (with pkgs.haskellPackages;
    [
      # Binaries
      cabal-install
      cabal-fmt
      fourmolu

      # Libraries
      base
      wreq
      text
      aeson
      lens
      async
    ]
    );
}
