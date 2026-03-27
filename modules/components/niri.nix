{ ... }:
{
  flake.nixosModules.cmp-niri-sys =
    { pkgs, ... }:
    {
      programs.niri.enable = true;

      services.displayManager.ly.enable = true;

      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.ly.enableGnomeKeyring = true;

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-gtk
        ];
        config.common.default = [
          "gnome"
          "gtk"
        ];
      };

      environment.systemPackages = with pkgs; [
        wl-clipboard
        brightnessctl
        adwaita-icon-theme
        hicolor-icon-theme
        xdg-user-dirs
        app2unit
      ];

      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      xdg.icons.enable = true;
    };

  flake.homeModules.cmp-niri-home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bluetui
        font-awesome
        libnotify
        nautilus
        playerctl
        seahorse
        slurp
        wl-screenrec
        noctalia-qs
        noctalia-shell
      ];

      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };
        gtk4.theme.name = "noctalia";
      };

      services.polkit-gnome.enable = true;
    };
}
