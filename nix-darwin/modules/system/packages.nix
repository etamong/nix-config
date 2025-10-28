{ config, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = (with pkgs; [
    # Essential tools
    btop
    curl
    git
    gnupg
    htop
    jq
    ncdu
    ripgrep
    tree
    wget
    yq

    # DevOps/SRE/Cloud Engineering tools
    kubectl
    kubectx
    k9s
    kubernetes-helm
    terraform
    terragrunt
    ansible
    docker
    docker-compose
    podman
    awscli2
    azure-cli
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])

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

    # Database tools
    postgresql

    # Other useful tools
    tmux
    screen
    rsync
    unzip
    watch
    zip
  ]) ++ [
    # Use unstable channel for teleport_17
    pkgs.unstable.teleport_17
  ];
}
