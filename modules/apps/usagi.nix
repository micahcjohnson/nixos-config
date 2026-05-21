{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.usagi =
        let
          # https://github.com/brettchalupa/usagi/releases
          version = "1.0.0";

          pname = "usagi";
          src = pkgs.fetchurl {
            url = "https://github.com/brettchalupa/usagi/releases/download/v${version}/usagi-${version}-linux-x86_64.tar.gz";
            hash = "sha256:3976fa2de170110e43fb5c2c951d8fef6130325265cf61f8b505a8a6e69dbbca";
          };
        in
        pkgs.stdenv.mkDerivation {
          inherit pname version src;
          sourceRoot = ".";

          nativeBuildInputs = [ pkgs.autoPatchelfHook ];
          buildInputs = [
            pkgs.stdenv.cc.cc.lib
            pkgs.zlib
          ];

          runtimeDependencies = with pkgs; [
            alsa-lib
            libpulseaudio
            libGL
            libx11
            libxcursor
            libxext
            libxi
            libxinerama
            libxrandr
            libxrender
            libxxf86vm
          ];

          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall
            install -Dm755 usagi $out/bin/usagi
            runHook postInstall
          '';
        };
    };
}
