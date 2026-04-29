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

          # Electron ignores XCURSOR_THEME and reads the cursor theme name from GTK
          # settings, which aren't available inside the FHS sandbox. Expanding the
          # cursor search path lets it find ~/.icons/default/index.theme, which
          # home-manager sets up to inherit from the stylix cursor theme.
          profile = ''
            export XCURSOR_PATH="$HOME/.icons:$HOME/.local/share/icons:/usr/share/icons:/usr/share/pixmaps"
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
