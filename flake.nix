{
  description = "Flake containing VuePress infrastructure";

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
        devShells = with pkgs; rec {
          mwe = mkShell {
            packages = [
              importNpmLock.hooks.linkNodeModulesHook
              nodejs
            ];

            npmDeps = importNpmLock.buildNodeModules {
              npmRoot = ./.;
              inherit nodejs;
            };

            shellHook = ''
              echo "Buggy tooling does not reliably run setup hook \"linkNodeModulesHook\": Running it explicitly...";
              linkNodeModulesHook;
              echo "VuePress development environment is ready.";
              echo -e "\e[1;32mTo start the dev server, run: npm run docs:dev\e[0m";
            '';
          };
          default = mwe;
        };

        packages = with pkgs; rec {
          mwe = buildNpmPackage {
            pname = "vuepress-nix-mwe";
            version = "0.0.1";
            src = ./.;

            npmDeps = importNpmLock {
              npmRoot = ./.;
            };

            npmBuildScript = "docs:build";

            npmConfigHook = importNpmLock.npmConfigHook;

            installPhase = ''
              cp -r .vuepress/dist $out/
            '';
          };
          default = mwe;
        };
      }
    );
}
