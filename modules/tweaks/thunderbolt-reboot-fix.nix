{ ... }:
{
  flake.nixosModules.twk-thunderbolt-reboot-fix =
    { pkgs, ... }:
    {
      # Rebooting with a Thunderbolt dock plugged in hangs after the
      # display powers off and never power-cycles. Unbinding the
      # thunderbolt PCI devices before shutdown tears down the dock's
      # PCIe tunnel cleanly and avoids the hang.
      systemd.services.thunderbolt-shutdown-unbind = {
        description = "Unbind Thunderbolt controllers before shutdown/reboot";
        wantedBy = [ "shutdown.target" ];
        before = [ "shutdown.target" ];
        unitConfig.DefaultDependencies = false;
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "thunderbolt-shutdown-unbind" ''
            for dev in /sys/bus/pci/drivers/thunderbolt/0000:*; do
              [ -e "$dev" ] || continue
              echo -n "$(basename "$dev")" > /sys/bus/pci/drivers/thunderbolt/unbind
            done
          '';
        };
      };
    };
}
