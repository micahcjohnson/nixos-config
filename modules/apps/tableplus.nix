{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.tableplus =
        let
          # Find this info at https://tableplus.com/blog/2020/01/changelogs-linux.html.
          version = "1.6.0";
          build-number = "302";

          pname = "tableplus";
          src = pkgs.fetchurl {
            url = "https://files.tableplus.com/linux/x64/${build-number}/TablePlus-x64.AppImage";
            # This will change when build numbers change. Run `curl -s [url] | sha256sum`
            hash = "sha256:fa11a17b28b3dfe88c79cbc25a962280ed64c1aaa88412f1057beed62f32770a";
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
