{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.usagi =
        let
          # https://github.com/brettchalupa/usagi/releases
          version = "0.4.0";

          pname = "usagi";
          src = pkgs.fetchurl {
            url = "https://github.com/brettchalupa/usagi/releases/download/v${version}/usagi-${version}-linux-x86_64.tar.gz";
            hash = "sha256:7ed5b36054a9634a6469c3b77ec36303779e2bfd1846d819b90085cf700447df";
          };
        in
        pkgs.stdenv.mkDerivation {
          inherit pname version src;
          sourceRoot = ".";

          nativeBuildInputs = [ pkgs.autoPatchelfHook ];
          buildInputs = [ pkgs.stdenv.cc.cc.lib ];

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
