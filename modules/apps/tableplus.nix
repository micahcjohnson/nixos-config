{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.tableplus =
        let
          # Find this info at https://tableplus.com/blog/2020/01/changelogs-linux.html.
          version = "1.5.4";
          build-number = "298";

          pname = "tableplus";
          src = pkgs.fetchurl {
            url = "https://files.tableplus.com/linux/x64/${build-number}/TablePlus-x64.AppImage";
            # This will change when build numbers change. Run `curl -s [url] | sha256sum`
            hash = "sha256:f6f40ebfea12daaf66021fe4fe17facd9f6c561a51fabbbfd46cbc8f7d1b2424";
          };
          contents = pkgs.appimageTools.extract { inherit pname version src; };
        in
        pkgs.appimageTools.wrapType2 {
          inherit pname version src;

          # Several tweaks to fix GTK/system theming issues with cursor and colors.
          profile = ''
            export XCURSOR_PATH="$HOME/.icons:$HOME/.local/share/icons:/usr/share/icons:/usr/share/pixmaps"
            export XDG_DATA_DIRS="$HOME/.nix-profile/share:$HOME/.local/share:''${XDG_DATA_DIRS:-/usr/share}"
            if [ -r "$HOME/.config/gtk-3.0/settings.ini" ]; then
              _gtk_theme=$(/usr/bin/awk -F= '/^gtk-theme-name[[:space:]]*=/ { gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); print $2; exit }' "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null)
              if [ -n "$_gtk_theme" ]; then
                export GTK_THEME="$_gtk_theme"
              fi
              unset _gtk_theme
            fi
          '';

          extraInstallCommands = ''
            install -m 444 -D ${contents}/${pname}-appimage.desktop -t $out/share/applications
            substituteInPlace $out/share/applications/${pname}-appimage.desktop \
              --replace-warn 'Exec=${pname}' "Exec=$out/bin/${pname}"
            cp -r ${contents}/usr/share/icons $out/share
          '';
        };
    };
}
