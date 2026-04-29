{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.helium =
        let
          # https://github.com/imputnet/helium-linux/releases
          version = "0.11.6.1";

          pname = "helium";
          src = pkgs.fetchurl {
            url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
            # Listed with the release file.
            hash = "sha256:36fb1255e2abf36304f283eea54f0eca1f486d87abc40589e6f463be3e16c8ba";
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
