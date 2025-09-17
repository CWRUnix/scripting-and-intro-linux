{
  description = "Obsidian notes vault flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShells = {
          default = pkgs.mkShell {
            packages = [
              pkgs.mermaid-cli
              pkgs.typst
              pkgs.typst-lsp
              pkgs.typstyle
              pkgs.bun
              (pkgs.python3.withPackages (pyPkgs: (with pyPkgs; [
                ipykernel
                jupyterlab
                jupyterlab-server
                matplotlib
                numpy
                pandas
                scipy
                pytest
                scikit-learn
              ])))
              pkgs.python312Packages.jupyterlab
              pkgs.python312Packages.jupyterlab-server
              pkgs.jupyter
              pkgs.quarto
              pkgs.black
              pkgs.texlab
            ];
          };
        };
        apps = {
          backup = flake-utils.lib.mkApp {
            drv = pkgs.writeShellApplication {
              name = "backup";
              text = builtins.readFile ./.scripts/backup.sh;
              runtimeInputs = [];
            };
          };
        };
      }
    );
}
