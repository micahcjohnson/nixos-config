{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.helium =
        let
          # https://github.com/imputnet/helium-linux/releases
          version = "0.11.3.2";

          pname = "helium";
          src = pkgs.fetchurl {
            url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
            # Listed with the release file.
            hash = "sha256:e607722a0d76655da1a5fd112fe7a82676b0b96fc9f0da1b886fb3100d083870";
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
