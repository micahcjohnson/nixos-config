{ ... }:
{
  flake.homeModules.helix =
    { pkgs, pkgs-unstable, ... }:
    let
      settings = {
        editor = {
          color-modes = true;
          idle-timeout = 100;

          end-of-line-diagnostics = "hint";
          inline-diagnostics.cursor-line = "error";
        };

        keys.normal = {
          "C-A-h" = "jump_view_left";
          "C-A-j" = "jump_view_down";
          "C-A-k" = "jump_view_up";
          "C-A-l" = "jump_view_right";

          "C-A-q" = "wclose";
          "-" = "hsplit";
          "\\" = "vsplit";
        };
      };

      languages = {
        language-server = with pkgs-unstable; {
          typescript-language-server = {
            command = "${nodePackages.typescript-language-server}/bin/typescript-language-server";
            args = [ "--stdio" ];
          };
          tailwindcss-ls = {
            command = "${tailwindcss-language-server}/bin/tailwindcss-language-server";
            args = [ "--stdio" ];
          };
          # causing build failure 2026-02-12
          # superhtml-lsp = {
          #   command = "${superhtml}/bin/superhtml";
          #   args = [ "lsp" ];
          # };
          vscode-css-language-server = {
            command = "${vscode-css-languageserver}/bin/vscode-css-languageserver";
          };
          vscode-json-language-server = {
            command = "${vscode-json-languageserver}/bin/vscode-json-languageserver";
          };
          agent-lsp-dev = {
            command = "${nodejs}/bin/node";
            args = [
              "/home/micah/CLT/misc/agent-lsp/out/server.js"
              "--stdio"
            ];
            environment = {
              PATH = "/etc/profiles/per-user/micah/bin";
            };
          };
          claude-reviewer-lsp-dev = {
            command = "/home/micah/CLT/misc/claude-reviewer-lsp/out/claude-reviewer-lsp";
            args = [ "--stdio" ];
            environment = {
              PATH = "/etc/profiles/per-user/micah/bin";
            };
          };
        };

        # Will need to revisit this if any languages require more configuration
        # than simply a list of LSPs.
        language =
          let
            serversByLanguage = {
              "css" = [
                "vscode-css-language-server"
                "tailwindcss-ls"
              ];
              "html" = [
                "superhtml-lsp"
                "tailwindcss-ls"
              ];
              "jsx" = [
                "typescript-language-server"
                "tailwindcss-ls"
              ];
              "tsx" = [
                "typescript-language-server"
                "tailwindcss-ls"
              ];
            };
          in
          map (
            { name, value }:
            {
              inherit name;
              language-servers = value;
            }
          ) (pkgs.lib.attrsToList serversByLanguage);
      };
    in
    {
      programs.helix = {
        enable = true;
        inherit settings languages;
      };
      programs.bash.bashrcExtra = ''
        # set $EDITOR if set to default (perhaps there is a way to replace nano)
        [[ "$EDITOR" == "nano" ]] && export EDITOR=hx
      '';
    };
}
