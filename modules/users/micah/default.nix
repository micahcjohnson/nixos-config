{ self, inputs, ... }:
{
  flake.homeModules.micah =
    { pkgs, config, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      imports =
        with self.homeModules;
        [
          bash
          ghostty
          helix
          vcs
          cmp-clt-home
          cmp-niri-home
          cmp-stylix-home
        ]
        ++ [
          inputs.nix-index-database.homeModules.default
          inputs.zen-browser.homeModules.beta
        ];

      home.username = "micah";
      home.homeDirectory = "/home/micah";

      home.packages =
        let
          nixpkgs-pkgs = with pkgs; [
            # Desktop apps
            aseprite
            obsidian
            blender
            blockbench
            zed-editor
            godot

            # build failing 4/13 :(
            # cemu

            # Terminal utilities
            btop
            jq
            ripgrep
            bat
            zip
            unzip
            pnpm
            nodejs
            just

            # adds some utilities used by MO2
            qt5.qttools
            p7zip
            zenity

            nil
            nixd

            # Fonts
            noto-fonts
            nerd-fonts.fira-code
            nerd-fonts.monaspace
          ];
          llm-agents-pkgs = with inputs.llm-agents.packages.${system}; [
            claude-code
            opencode
            pi
          ];
          custom-pkgs = with self.packages.${system}; [
            helium
            tableplus
            usagi
          ];
        in
        nixpkgs-pkgs ++ llm-agents-pkgs ++ custom-pkgs;

      home.file.".fonts".source =
        let
          fontPackages = with pkgs; [
            nerd-fonts.fira-code
            dejavu_fonts
          ];
        in
        pkgs.symlinkJoin {
          name = "home-fonts";
          paths = map (p: "${p}/share/fonts") fontPackages;
        };

      # Electron apps ignore XCURSOR_THEME and fall back to the "default" cursor
      # theme inside their FHS sandbox. This alias points "default" at the stylix
      # cursor theme so libwayland-cursor loads the correct cursors.
      home.file.".icons/default/index.theme".text = ''
        [Icon Theme]
        Inherits=${config.stylix.cursor.name}
      '';
      home.sessionVariables.XCURSOR_PATH = "$HOME/.icons:$HOME/.local/share/icons:/usr/share/icons:/usr/share/pixmaps";

      programs.zen-browser.enable = true;
      programs.nix-index-database.comma.enable = true;

      systemd.user.startServices = "sd-switch";

      home.stateVersion = "25.05";
    };
}
