{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.helium =
        let
          # https://github.com/imputnet/helium-linux/releases
          version = "0.13.5.1";

          pname = "helium";
          src = pkgs.fetchurl {
            url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
            # Listed with the release file.
            hash = "sha256:5409dc2fbf27c974513543d9d9cd10b9dc45adfc72eed5c4d8d14de2d79e7b39";
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
