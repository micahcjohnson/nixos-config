{ self, inputs, ... }:
{
  flake.nixosModules.cmp-niri-sys =
    { pkgs, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
      };

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
      ];

      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };
      };

      services.polkit-gnome.enable = true;
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;

        settings = {
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          spawn-at-startup = [
            (lib.getExe self'.packages.noctalia)
          ];

          input = {
            keyboard = {
              xkb.layout = "us";
              repeat-delay = 180;
              repeat-rate = 40;
            };
            touchpad = {
              tap = null;
              natural-scroll = null;
              accel-speed = 0.2;
              scroll-factor = 0.4;
            };

            warp-mouse-to-focus = null;
            focus-follows-mouse._attrs.max-scroll-amount = "25%";
          };

          outputs = {
            "eDP-1" = {
              # Built-in Framework display.
              position._attrs = {
                x = 0;
                y = 0;
              };
              variable-refresh-rate = null;
              scale = 1.75;
            };

            "Dell Inc. DELL P2219H 9T3MBF3" = {
              # Landscape Dell monitor @ home.
              position._attrs = {
                x = 1646;
                y = 0;
              };
            };

            "Dell Inc. DELL P2219H 3V2MBF3" = {
              # Portrait Dell monitor @ home.
              position._attrs = {
                x = 3566;
                y = -466;
              };
              transform = "270";
            };

            "Dell Inc. DELL S2722QC 97CWH24" = {
              # 4K monitor @ office.
              position._attrs = {
                x = 0;
                y = -1440;
              };
              scale = 1.5;
            };
          };

          layout = {
            gaps = 6;
            center-focused-column = "never";

            focus-ring.width = 2;
          };

          window-rules = [
            {
              geometry-corner-radius = 10;
              clip-to-geometry = true;
            }
            {
              matches = [
                { app-id = "dev.zed.Zed"; }
                { app-id = "^TablePlus$"; }
              ];
              draw-border-with-background = false;
            }
          ];

          prefer-no-csd = null;
          screenshot-path = "~/Pictures/Screenshots/screenshot.%Y-%m-%d.%H-%M-%S.png";

          hotkey-overlay.skip-at-startup = null;
          animations.slowdown = 0.9;

          layer-rules = [
            {
              matches = [ { namespace = "^notifications$"; } ];
              block-out-from = "screencast";
            }
          ];

          binds =
          let
            noctalia-ipc = "${lib.getExe self'.packages.noctalia} ipc call";
          in
          {
            "Mod+T" = {
              _attrs = {
                cooldown-ms = 500;
                hotkey-overlay-title = "Open a Terminal: ghostty";
              };
              spawn-sh = "ghostty +new-window";
            };

            "Mod+Space".spawn-sh = "${noctalia-ipc} launcher toggle";

            "Mod+Q".close-window = null;

            "Mod+H".focus-column-left = null;
            "Mod+J".focus-window-or-workspace-down = null;
            "Mod+K".focus-window-or-workspace-up = null;
            "Mod+L".focus-column-right = null;

            "Mod+Ctrl+H".move-column-left = null;
            "Mod+Ctrl+J".move-window-down-or-to-workspace-down = null;
            "Mod+Ctrl+K".move-window-up-or-to-workspace-up = null;
            "Mod+Ctrl+L".move-column-right = null;

            "Mod+Home".focus-column-first = null;
            "Mod+End".focus-column-last = null;
            "Mod+Ctrl+Home".move-column-to-first = null;
            "Mod+Ctrl+End".move-column-to-last = null;

            "Mod+Shift+H".focus-monitor-left = null;
            "Mod+Shift+J".focus-monitor-down = null;
            "Mod+Shift+K".focus-monitor-up = null;
            "Mod+Shift+L".focus-monitor-right = null;

            "Mod+Shift+Ctrl+H".move-column-to-monitor-left = null;
            "Mod+Shift+Ctrl+J".move-column-to-monitor-down = null;
            "Mod+Shift+Ctrl+K".move-column-to-monitor-up = null;
            "Mod+Shift+Ctrl+L".move-column-to-monitor-right = null;

            "Mod+BracketLeft".consume-or-expel-window-left = null;
            "Mod+BracketRight".consume-or-expel-window-right = null;

            "Mod+R".switch-preset-column-width = null;
            "Mod+F".maximize-column = null;
            "Mod+Shift+F".fullscreen-window = null;

            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";
            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";

            "Mod+V".toggle-window-floating = null;
            "Mod+Shift+V".switch-focus-between-floating-and-tiling = null;

            "Mod+W".toggle-column-tabbed-display = null;

            "Print".screenshot = null;
            "Ctrl+Print".screenshot-screen = null;
            "Alt+Print".screenshot-window = null;
            # "Mod+Print".spawn-sh = TODO screen recording script

            "Mod+Escape" = {
              _attrs.allow-inhibiting = false;
              toggle-keyboard-shortcuts-inhibit = null;
            };

            "Mod+Shift+E".quit = null;
            "Ctrl+Alt+Delete".quit = null;

            "Mod+Shift+P".power-off-monitors = null;
          };
        };
      };
    };
}
