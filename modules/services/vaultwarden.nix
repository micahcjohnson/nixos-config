{ ... }:
{
  flake.nixosModules.svc-vaultwarden =
    { pkgs, ... }:
    {
      # Creates a local vaultwarden server for password management at
      # https://vault.local:4443 (Self-signed cert)

      environment.systemPackages = with pkgs; [
        vaultwarden
      ];

      networking.hosts = {
        "127.0.0.1" = [
          "vault.local"
        ];
      };

      services.vaultwarden = {
        enable = true;
        dbBackend = "sqlite";
        config = {
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
          DOMAIN = "https://vault.local";
          SIGNUPS_ALLOWED = false;
        };
        environmentFile = "/var/lib/vaultwarden/vaultwarden.env";
      };

      services.traefik = {
        enable = true;

        staticConfigOptions = {
          entryPoints = {
            websecure = {
              address = ":4443";
            };
          };

          # uncomment for troubleshooting
          # api.dashboard = true;
          # api.insecure = true;
        };

        dynamicConfigOptions = {
          http = {
            routers.vaultwarden = {
              rule = "Host(`vault.local`)";
              service = "vaultwarden";
              entrypoints = [ "websecure" ];
              tls = { }; # Auto-generates self-signed certificate
            };

            services.vaultwarden = {
              loadBalancer.servers = [
                { url = "http://127.0.0.1:8222"; }
              ];
            };
          };
        };
      };

      # Create vaultwarden directory
      systemd.tmpfiles.rules = [
        "d /var/lib/vaultwarden 0750 vaultwarden vaultwarden -"
      ];
    };
}
