{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.usagi =
        let
          # https://github.com/brettchalupa/usagi/releases
          version = "0.8.0";

          pname = "usagi";
          src = pkgs.fetchurl {
            url = "https://github.com/brettchalupa/usagi/releases/download/v${version}/usagi-${version}-linux-x86_64.tar.gz";
            hash = "sha256:981b2fc79e6b26488b3c8d1a9f02911f04713ec9ff39181cd48bfec02f1f9087";
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
