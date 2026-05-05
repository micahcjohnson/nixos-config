{ ... }:
{
  flake.nixosModules.twk-bluetooth =
    { ... }:
    {
      # Resume hook (rmmod/modprobe btusb) temporarily disabled for diagnosis —
      # checking whether the s2idle wedge is kernel/chip-level or userspace.
      # See memory: project_bluetooth_mt7925.
    };
}
