{
  description = "Bradford's Nix Environment";

  inputs = {
    # All packages should follow nixpkgs-unstable for macOS
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    # Nix-Darwin
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # HM-manager for dotfile/user management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # WM
    yabai-src = {
      url = "github:koekeishiya/yabai";
      flake = false;
    };
    # Themeing
    base16 = {
      url = "github:shaunsingh/base16.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # IBM-Carbon-Theme (see IBM-design: colors)
    base16-carbon-dark = {
      url = "github:shaunsingh/base16-carbon-dark";
      flake = false;
    };
    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-config = {
      url = "path:./modules/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixvim.follows = "nixvim";
    };
  };
  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    let pkgs = nixpkgs.legacyPackages."aarch64-darwin";
    in {
      # packages."aarch64-darwin" = {
      #   pragmata-pro = pkgs.callPackage ./pkgs/pragmata-pro { };
      # };

      ####### Laptop Config #######
      darwinConfigurations."bradford-mbp" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit self inputs; };
        modules = [
          ./modules/mac.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.bradfordtoney = {
                imports = [
                  inputs.base16.hmModule
                  ./modules/home.nix
                  # ./modules/theme.nix
                ];
              };
            };
          }
          ({ ... }: {
            system.primaryUser = "bradfordtoney";
          })
          ({ config, pkgs, lib, ... }: {
            nix.enable = true;
            security.pam.services.sudo_local.touchIdAuth = true;
            # Match existing nixbld group GID from previous Nix installation
            ids.gids.nixbld = 30000;
            nixpkgs = {
              config.allowBroken = true;
              config.allowUnfree = true;
              overlays = with inputs; [
                nur.overlays.default
              ];
            };
          })
        ];
      };

      ####### Mac Studio Config #######
      darwinConfigurations."bradford-macstudio" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit self inputs; };
        modules = [
          ./modules/mac.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.bradford = {
                imports = [
                  inputs.base16.hmModule
                  ./modules/home.nix
                ];
              };
            };
          }
          ({ ... }: {
            system.primaryUser = "bradford";
          })
          ({ config, pkgs, lib, ... }: {
            nix.enable = true;
            security.pam.services.sudo_local.touchIdAuth = true;
            nixpkgs = {
              config.allowBroken = true;
              config.allowUnfree = true;
              overlays = with inputs; [
                nur.overlays.default
              ];
            };
          })
        ];
      };
    };
}
