{ ... }:
{
  flake.homeModules.ghostty =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = pkgs.ghostty;
        enableBashIntegration = true;

        settings = {
          font-family = "FiraCode Nerd Font";
          font-feature = [
            "ss01"
            "ss04"
            "ss06"
            "ss08"
            "cv06"
            "cv13"
            "cv29"
            "cv30"
            "cv31"
          ];
          font-size = 10;

          window-padding-balance = true;
          window-padding-color = "extend";
          window-inherit-working-directory = true;

          focus-follows-mouse = true;

          quit-after-last-window-closed = true;
          quit-after-last-window-closed-delay = "5m";

          keybind = [
            # splits
            "ctrl+shift+backslash=new_split:right"
            "ctrl+shift+o=unbind"
            "ctrl+shift+minus=new_split:down"
            "ctrl+shift+e=unbind"

            # movement
            "ctrl+shift+h=goto_split:left"
            "ctrl+alt+up=unbind"
            "ctrl+shift+j=goto_split:down"
            "ctrl+alt+left=unbind"
            "ctrl+shift+k=goto_split:up"
            "ctrl+alt+down=unbind"
            "ctrl+shift+l=goto_split:right"
            "ctrl+alt+right=unbind"
          ];
        };
      };
    };
}
