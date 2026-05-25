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
          gameoflife_fg = "0x00F0F0F0";

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
        ironbar
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

      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "${pkgs.ghostty}/bin/ghostty -e";
            launch-prefix = "${pkgs.app2unit}/bin/app2unit";

            horizontal-pad = 10;
            vertical-pad = 10;
          };

          border = {
            width = 2;
            radius = 0;
          };
        };
      };
      programs.hyprlock.enable = true;
      # services.hypridle.enable = true;
      services.polkit-gnome.enable = true;
    };
}
