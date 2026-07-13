{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.helium =
        let
          # https://github.com/imputnet/helium-linux/releases
          version = "0.14.5.1";

          pname = "helium";
          src = pkgs.fetchurl {
            url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
            # Listed with the release file.
            hash = "sha256:24ce139b82def5771fab77c5304bbf0c82baf35ec5120050dab4b0634f77174e";
          };
          contents = pkgs.appimageTools.extract { inherit pname version src; };
        in
        pkgs.appimageTools.wrapType2 {
          inherit pname version src;

          extraInstallCommands = ''
            install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
            substituteInPlace $out/share/applications/${pname}.desktop \
              --replace-warn 'Exec=${pname}' "Exec=$out/bin/${pname}"
            cp -r ${contents}/usr/share/icons $out/share
          '';
        };
    };
}
