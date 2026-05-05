{ ... }:
{
  flake.nixosModules.twk-bluetooth =
    { pkgs, ... }:
    {
      # MT7925 BT controller wedges across s2idle resume (lid close/open).
      # Reload btusb on resume to bring it back. See memory: project_bluetooth_mt7925.
      powerManagement.resumeCommands = ''
        ${pkgs.kmod}/bin/rmmod btusb || true
        ${pkgs.kmod}/bin/modprobe btusb
      '';
    };
}
