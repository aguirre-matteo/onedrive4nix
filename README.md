# Onedrive on Nix
## What is this?
> [!NOTE]
> This module has been merged into Home-Manager's unstable branch

This repository offers a Home-Manager module for configurating
the [OneDrive Client for Linux](https://github.com/abraunegg/onedrive) using Nix.

# Installation

This guide assumes you have flakes enabled on your NixOS or Nix config.

## First step

Add this flake as an input in your `flake.nix` that contains your NixOS configuration.

```flake.nix 
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ...
    onedrive4nix.url = "github:aguirre-matteo/onedrive4nix";
  };
}
```
The provided Home-Manager module can be found at `inputs.distrobox4nix.homeManagerModule`.

## Second step

Add the module to Home-Manager's `sharedModules` list.

```flake.nix
outputs = { self, nixpkgs, home-manager, ... }@inputs: {
  nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
    modules = [
      ./configuration.nix
      ./hardware-configuration.nix 
      
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExntesion = "bkp";

          sharedModules = [
            inputs.onedrive4nix.homeManagerModule # <--- this will enable the module
          ];

          user.yourUserName = import ./path/to/home.nix
        };
      }
    ]; 
  };
};
```

# Configuration

The following options are available at `programs.onedrive`:

`enable`

Whatever to enable or not OneDrive. Default: false

`package`

The OneDrive package will be used. This option is usefull when
overriding the original package. Default: `pkgs.onedrive`

`settings`
All the configurations for OneDrive. All options can be found
in the [OneDrive repo](https://github.com/abraunegg/onedrive/blob/master/config).

## Example config 

```home.nix
{
  programs.onedrive = {
    enable = true;
    settings = {
      check_nomount = "false";
      check_nosync = "false";
      classify_as_big_delete = "1000";
      cleanup_local_files = "false";
      disable_notifications = "false";
      no_remote_delete = "false";
      rate_limit = "0";
      resync = "false";
      skip_dotfiles = "false";
    };
  };
}
```
