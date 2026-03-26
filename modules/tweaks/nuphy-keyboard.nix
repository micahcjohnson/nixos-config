{ ... }:
{
  flake.nixosModules.twk-nuphy-keyboard =
    { ... }:
    {
      # Overrides the handling of the fn key on the Nuphy keyboard so
      # that the F keys can be used.
      boot.extraModprobeConfig = ''
        options hid_apple fnmode=0
      '';

      boot.kernelModules = [ "hid-apple" ];
    };
}
