{ ... }:
{
  flake.nixosModules.cmp-clt-sys =
    { pkgs, ... }:
    {
      networking.hosts = {
        "127.0.0.1" = [
          "dev.cltexam.com"
          "clt2-dev.cltexam.com"
          "app2-dev.cltexam.com"
          "backroom-dev.cltexam.com"
        ];
      };

      environment.systemPackages = with pkgs; [
        docker-compose
      ];

      environment.sessionVariables.COMPOSE_BAKE = "true";
    };

  flake.homeModules.cmp-clt-home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        autossh
        awscli2 # Intentionally not using the enable option so that it can manage its own config
        eksctl
        kubernetes
        slack
        terraform
      ];

      systemd.user.services.cltvpn = {
        Unit = {
          Description = "Port forwards for CLT services";
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.writeShellScript "cltvpn" ''
            ssh-add /home/micah/.ssh/id_ed25519
            /home/micah/CLT/classiclearning/clt-vpn-scripts/clt-port-forwards.sh
          ''}";
          Restart = "on-failure";
          Environment = [ "USE_AUTOSSH=true" ];
        };
      };

      programs.bash.bashrcExtra = ''
        # creates a PR for an already pushed jj bookmark
        ghpr() {
          local issue_num=$1
          local description=$2

          local bookmark=$(jj bookmark list -T 'self.name() ++ "\n"' | rg "$issue_num")
          if [[ -z "$bookmark" ]]; then
            echo "error: no bookmark found for issue $issue_num"
            return 1
          fi

          gh pr create \
            -B staging \
            -H "$bookmark" \
            -t "classiclearning/Issues#$issue_num: $description" \
            -b "closes classiclearning/Issues#$issue_num"
        }
      '';
    };
}
