{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.helium =
        let
          # https://github.com/imputnet/helium-linux/releases
          version = "0.9.4.1";

          pname = "helium";
          src = pkgs.fetchurl {
            url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
            # Listed with the release file.
            hash = "sha256:37981d5aec4eac8b9d271ff89d8a38fd2292c5a9294c5bcbe33cc1cafe829ee8";
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
