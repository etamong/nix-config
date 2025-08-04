{ config, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Essential tools
    btop
    curl
    git
    gnupg
    htop
    jq
    tree
    wget
    yq

    # DevOps/SRE/Cloud Engineering tools
    kubectl
    kubectx
    k9s
    terraform
    terragrunt
    ansible
    docker
    docker-compose
    podman
    awscli2
    azure-cli
    google-cloud-sdk

    # Monitoring and observability
    prometheus
    grafana

    # Python and development
    python3
    python3Packages.pip
    python3Packages.virtualenv
    nodejs

    # Network tools
    nmap
    dig
    tcpdump

    # Other useful tools
    tmux
    screen
    rsync
    unzip
    watch
    zip
    raycast
    
    # Terminal emulator
    ghostty
  ];
}