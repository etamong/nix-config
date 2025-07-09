{ config, pkgs, ... }: {
  # Set the path to the darwin configuration
  environment.darwinConfig = "$HOME/sources/github.com/etamong/nix-config/nix-darwin";

  # Nix package manager settings
  nix = {
    package = pkgs.nix;

    # Necessary for using flakes on this system.
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "@admin" "jhlee" "root" ];
      # Allow jhlee to run nix commands
      allowed-users = [ "@admin" "jhlee" "root" ];
      # Enable user namespace for non-root builds
      sandbox = true;
      build-users-group = "nixbld";
    };

    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    # Ensure PATH includes standard system directories
    shellInit = ''
      export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
    '';
  };

  system.defaults = {
    # dock
    dock = {
      autohide = true;
      mru-spaces = false;
    };

    # finder
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # Set primary user for homebrew and system defaults
  system.primaryUser = "jhlee";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Users
  users.users = {
    jhlee = {
      name = "jhlee";
      home = "/Users/jhlee";
    };
  };

  # https://mynixos.com/nix-darwin/option/security.pam.services.sudo_local.touchIdAuth
  security.pam.services = {
    sudo_local = {
      touchIdAuth = true;
    };
  };

  # Enable podman socket service
  launchd.user.agents.podman = {
    command = "${pkgs.podman}/bin/podman system service --time=0 unix:///Users/jhlee/.local/share/containers/podman/machine/podman-machine-default/podman.sock";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}