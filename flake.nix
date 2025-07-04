{
  description =
    "dump2llm: dump a Git repo or entire path as text for LLM chats";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages = {
          default = self.packages.${system}.dump2llm;

          dump2llm = pkgs.stdenv.mkDerivation rec {
            pname = "dump2llm";
            version = "0.0.4";
            src = ./.;

            buildInputs = with pkgs; [ bash git ];

            patchPhase = ''
              runHook prePatch
              patchShebangs .
              runHook postPatch
            '';

            doCheck = true;

            checkPhase = ''
              runHook preCheck

              # set up environment for tests
              export PATH=${pkgs.bash}/bin:${pkgs.git}/bin:$PATH

              # make test script executable
              chmod +x dump2llm_test

              # run the test suite
              echo "running dump2llm test suite..."
              ./dump2llm_test

              runHook postCheck
            '';

            installPhase = ''
              mkdir -p $out/bin
              substitute ${pname} $out/bin/${pname} \
                --replace "/usr/bin/env bash" "${pkgs.bash}/bin/bash"
              chmod +x $out/bin/${pname}
            '';
            shellHook = ''
              export PATH=${pkgs.bash}/bin:${pkgs.git}/bin:$PATH
            '';

            meta = with pkgs.lib; {
              description =
                "dump a Git repo or entire path as text for LLM chats";
              homepage = "https://github.com/willyrgf/dump2llm";
              license = licenses.mit;
              platforms = platforms.all;
            };
          };
        };

        apps = {
          default = self.apps.${system}.dump2llm;

          dump2llm = {
            type = "app";
            program = "${self.packages.${system}.dump2llm}/bin/dump2llm";
            meta = self.packages.${system}.dump2llm.meta;
          };
        };

        devShells.default =
          pkgs.mkShell { buildInputs = with pkgs; [ bash git ]; };
      });
}
