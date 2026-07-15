{ self, inputs, ... }:
{
  flake.nixosConfigurations.azimir = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.azimirConfig

      inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      {
        system.configurationRevision = self.rev or self.dirtyRev or "dirty";
      }
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "bak";
        home-manager.users.micah = {
          imports = [ self.homeModules.micah ];
        };
      }
    ];
  };
}
