{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.usagi =
        let
          # https://github.com/brettchalupa/usagi/releases
          version = "0.7.2";

          pname = "usagi";
          src = pkgs.fetchurl {
            url = "https://github.com/brettchalupa/usagi/releases/download/v${version}/usagi-${version}-linux-x86_64.tar.gz";
            hash = "sha256:fa07aa08cfb9cc864a425e78975b2a5cfdab7d4e4974e6834b925a904ada0c49";
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
