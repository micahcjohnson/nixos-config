{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Pin for bluez 5.84 — see modules/tweaks/bluetooth.nix and memory project_bluetooth_mt7925.
    nixpkgs-bluez.url = "github:nixos/nixpkgs/b12141ef619e0a9c1c84dc8c684040326f27cdcc";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # App flakes
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        inputs.home-manager.flakeModules.home-manager
        (inputs.import-tree ./modules)
      ];
    };
}
