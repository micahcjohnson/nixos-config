{ ... }:
{
  flake.nixosModules.svc-steam =
    { pkgs, ... }:
    {
      programs.steam.enable = true;
      programs.steam.protontricks.enable = true;
      programs.steam.gamescopeSession.enable = true;

      environment.systemPackages = with pkgs; [
        mangohud
      ];

      programs.gamemode.enable = true;

      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };
      };
    };
}
