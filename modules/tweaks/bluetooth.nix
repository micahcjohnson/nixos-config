{ inputs, ... }:
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

      # Pin bluetoothd to bluez 5.84 — 5.86 (shipped in 2026-04-27 nixpkgs bump)
      # appears to disable the controller more aggressively under load. Only the
      # daemon is swapped; consumers like pipewire talk to it over dbus.
      hardware.bluetooth.package =
        inputs.nixpkgs-bluez.legacyPackages.${pkgs.stdenv.hostPlatform.system}.bluez;
    };
}
