{ ... }:
{
  flake.homeModules.bash =
    { ... }:
    {
      programs.bash.enable = true;

      programs.bash.bashrcExtra = ''
        # use half-bright text for direnv
        export DIRENV_LOG_FORMAT=$'\033[2mdirenv: %s\033[0m'

        # add manually-installed duckdb to path
        export PATH="/home/micah/.duckdb/cli/latest":$PATH
      '';

      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
        config = {
          global = {
            hide_env_diff = true;
          };
        };
      };

      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
        options = [ "--cmd cd" ];
      };

      programs.eza.enable = true;
    };
}
