# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell
#
# flake.nix - Nix Flake (RSR fallback for non-Guix systems)
# Primary package management: guix.scm
# Reference: https://nixos.wiki/wiki/Flakes

{
  description = "Misinformation Defence Platform - Guix channel/infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Development shell
        devShells.default = pkgs.mkShell {
          name = "misinformation-defence-platform";

          buildInputs = with pkgs; [
            # Core tools
            git
            gnumake
            just

            # Documentation
            asciidoctor

            # Guix compatibility (if available)
            # guix  # Uncomment on NixOS with Guix service

            # Security tools
            trufflehog
          ];

          shellHook = ''
            echo "Misinformation Defence Platform - Development Shell"
            echo "Primary: guix shell -D -f guix.scm"
            echo "Fallback: nix develop (current)"
            echo ""
            echo "RSR Compliance: Gold target"
            echo "License: AGPL-3.0-or-later"
          '';
        };

        # Package definition
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "misinformation-defence-platform";
          version = "0.1.0";

          src = ./.;

          meta = with pkgs.lib; {
            description = "Guix channel/infrastructure - part of the RSR ecosystem";
            homepage = "https://github.com/hyperpolymath/Misinformation-Defence-Platform";
            license = licenses.agpl3Plus;
            maintainers = [ ];
            platforms = platforms.all;
          };

          # Placeholder build - update when source code is added
          installPhase = ''
            mkdir -p $out/share/doc/misinformation-defence-platform
            cp -r docs/* $out/share/doc/misinformation-defence-platform/ 2>/dev/null || true
            cp README.adoc $out/share/doc/misinformation-defence-platform/ 2>/dev/null || true
            cp LICENSE.txt $out/share/doc/misinformation-defence-platform/ 2>/dev/null || true
          '';
        };
      }
    );
}
