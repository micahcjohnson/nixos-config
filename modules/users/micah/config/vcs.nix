{ ... }:
{
  flake.homeModules.vcs =
    { pkgs, ... }:
    let
      user = {
        name = "Micah Johnson";
        email = "mjohnson@cltexam.com";
      };
    in
    {
      programs.git = {
        enable = true;
        settings = { inherit user; };
      };

      programs.gh.enable = true;

      programs.jujutsu = {
        enable = true;
        package = pkgs.jujutsu;
        settings = {
          inherit user;
          ui.default-command = "log";
          ui.pager = "less -F";
        };
      };
    };
}
