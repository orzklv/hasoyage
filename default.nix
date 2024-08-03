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
      # base_4_20_0_0
      wreq
      text
      aeson
      lens
      async
    ]
    );
}
