{
  inputs = {
    opam-nix.url = "github:tweag/opam-nix";
    # nixpkgs.follows = "opam-nix/nixpkgs";
    flake-utils.follows = "opam-nix/flake-utils";
  };

  outputs = { self, flake-utils, opam-nix }: flake-utils.lib.eachDefaultSystem (system: let
    name = "aoc";
  in {
    defaultPackage = (opam-nix.lib.${system}.buildOpamProject {} name ./. {
      ocaml-base-compiler = "*";
    }).name;
  });
}
