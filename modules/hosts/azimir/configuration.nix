{ self, inputs, ... }:
{
  flake.nixosModules.azimirConfig =
    { pkgs, ... }:
    {
      imports = with self.nixosModules; [
        azimirHardware
        svc-steam
        svc-vaultwarden
        twk-nuphy-keyboard
        cmp-clt-sys
        cmp-niri-sys
        cmp-stylix-sys
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      # Pinned to nixpkgs-kernel (rev da5ad66) = kernel 7.0.5. 7.0.8 has a
      # btmtk/btusb regression that breaks MT7925 Bluetooth (WMT func ctrl
      # -22). Rest of the system still tracks the main nixpkgs input.
      boot.kernelPackages = inputs.nixpkgs-kernel.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_latest;
      boot.kernelModules = [ "uvcvideo" ];

      networking.hostName = "azimir";
      networking.networkmanager.enable = true;

      networking.firewall = {
        enable = true;

        # Allow docker containers on default network and compose networks to access host
        trustedInterfaces = [ "docker0" ];
        extraCommands = ''
          iptables -A INPUT -i br-+ -j ACCEPT
        '';
      };

      time.timeZone = "America/New_York";

      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      services.printing.enable = true;

      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      services.fwupd.enable = true;

      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;

      hardware.graphics.enable = true;
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };

      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;

        extraPackages = with pkgs; [ docker-buildx ];

        daemon.settings = {
          experimental = true;
        };
      };

      users.users.micah = {
        isNormalUser = true;
        description = "Micah";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
      };

      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep 5 --keep-since 3d";
        };
        flake = "/home/micah/nixos-config";
      };

      programs.nix-ld.enable = true;
      # programs.nix-ld.libraries = with pkgs; []; # Add any missing dylibs here.

      programs.appimage.enable = true;
      programs.appimage.binfmt = true;

      nix = {
        settings.experimental-features = [
          "nix-command"
          "flakes"
        ];

        # Sync nix command nixpkgs with system input.
        registry.nixpkgs.flake = inputs.nixpkgs;
      };

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = with pkgs; [
        git
        vim
        wget
        helix
      ];

      system.stateVersion = "25.05"; # This should stay the same
    };
}
