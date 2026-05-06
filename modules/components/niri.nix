{ ... }:
{
  flake.nixosModules.cmp-niri-sys =
    { pkgs, ... }:
    {
      programs.niri.enable = true;

      services.displayManager.ly = {
        enable = true;

        settings = {
          battery_id = "BAT1";
          bigclock = "en";
          bigclock_12hr = "true";

          animation = "gameoflife";
          gameoflife_entropy_interval = 10;
          gameoflife_initial_density = 0.4;

          shell = false;
          xinitrc = null;
        };
      };

      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.ly = {
        enableGnomeKeyring = true;
        fprintAuth = false;
      };

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
        xwayland-satellite
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
        swaybg
        hyprlock
        swaynotificationcenter
        gpu-screen-recorder
        noctalia-qs
        noctalia-shell
      ];

      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };
        gtk4.theme = null;
      };

      services.polkit-gnome.enable = true;
    };
}
