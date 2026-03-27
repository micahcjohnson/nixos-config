{ ... }:
{
  flake.nixosModules.cmp-stylix-sys =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";
        polarity = "dark";
      };
    };

  flake.homeModules.cmp-stylix-home =
    { pkgs, ... }:
    {
      stylix = {
        targets = {
          zed.enable = false;
          zen-browser.enable = false;
          ghostty.enable = false;
          helix.enable = false;
        };

        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 24;
        };

        fonts = {
          monospace = {
            package = pkgs.nerd-fonts.fira-code;
            name = "FiraCode Nerd Font";
          };
          serif = {
            package = pkgs.noto-fonts;
            name = "Noto Serif";
          };
          sansSerif = {
            package = pkgs.noto-fonts;
            name = "Noto Sans";
          };
          sizes = {
            applications = 10;
            terminal = 10;
            popups = 10;
          };
        };
      };
    };
}
