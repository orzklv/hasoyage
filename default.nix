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
      wreq
      text
      aeson
      lens
      async
    ]
    );
  overrides = self: super: {
    ghc = pkgs.haskell.compiler.ghc981;
  };
}
