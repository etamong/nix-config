{ config, lib, pkgs, ... }:

let
  # Podman socket management scripts
  podman-socket-start = pkgs.writeScriptBin "podman-socket-start" ''
    #!${pkgs.bash}/bin/bash
    set -e

    SOCKET_PATH="/tmp/podman.sock"
    MAX_RETRIES=3
    RETRY_DELAY=2

    # Clean up existing socket
    rm -f "$SOCKET_PATH"

    # Kill any existing SSH connections to podman socket
    pkill -f "ssh.*podman.sock" || true

    # Get the running podman machine name and SSH port
    MACHINE_NAME=$(podman machine list --format="{{.Name}}" | grep "\\*" | sed "s/\\*//")
    if [ -z "$MACHINE_NAME" ]; then
      echo "No running podman machine found. Starting default machine..."
      podman machine start
      sleep 5
      MACHINE_NAME=$(podman machine list --format="{{.Name}}" | grep "\\*" | sed "s/\\*//")
    fi

    if [ -z "$MACHINE_NAME" ]; then
      echo "Failed to start podman machine"
      exit 1
    fi

    PORT=$(podman machine inspect "$MACHINE_NAME" | jq -r ".[0].SSHConfig.Port")
    if [ -z "$PORT" ] || [ "$PORT" = "null" ]; then
      echo "Failed to get SSH port for machine $MACHINE_NAME"
      exit 1
    fi

    echo "Starting podman socket proxy for machine: $MACHINE_NAME on port: $PORT"

    # Retry SSH connection with network interface reset
    for i in $(seq 1 $MAX_RETRIES); do
      echo "Attempt $i/$MAX_RETRIES: Establishing SSH connection..."

      # Reset network interface if this is not the first attempt
      if [ $i -gt 1 ]; then
        echo "Resetting network interface..."
        # Try to reset the primary network interface on macOS
        PRIMARY_INTERFACE=$(route get default | grep interface | awk '{print $2}')
        if [ -n "$PRIMARY_INTERFACE" ]; then
          sudo ifconfig "$PRIMARY_INTERFACE" down 2>/dev/null || true
          sleep 1
          sudo ifconfig "$PRIMARY_INTERFACE" up 2>/dev/null || true
          sleep 2
        fi
      fi

      # Try SSH connection
      if ssh -o StrictHostKeyChecking=no \
             -o ConnectTimeout=10 \
             -o ServerAliveInterval=60 \
             -o ServerAliveCountMax=3 \
             -o ControlMaster=auto \
             -o ControlPath="/tmp/podman-ssh-control-%r@%h:%p" \
             -o ControlPersist=600 \
             -i ~/.local/share/containers/podman/machine/machine \
             -L "$SOCKET_PATH:/run/user/$(id -u)/podman/podman.sock" \
             -N core@127.0.0.1 -p "$PORT" &
      then
        sleep 3
        if [ -S "$SOCKET_PATH" ]; then
          echo "Podman socket proxy started successfully"
          echo "Socket available at: $SOCKET_PATH"
          exit 0
        fi
      fi

      # Clean up failed attempt
      pkill -f "ssh.*podman.sock" || true
      rm -f "$SOCKET_PATH"

      if [ $i -lt $MAX_RETRIES ]; then
        echo "SSH connection failed, retrying in $RETRY_DELAY seconds..."
        sleep $RETRY_DELAY
      fi
    done

    echo "Failed to establish SSH connection after $MAX_RETRIES attempts"
    echo "Attempting to restart podman machine as last resort..."

    podman machine stop "$MACHINE_NAME" || true
    sleep 2
    podman machine start "$MACHINE_NAME" || true
    sleep 5

    # Final attempt after machine restart
    PORT=$(podman machine inspect "$MACHINE_NAME" | jq -r ".[0].SSHConfig.Port")
    ssh -o StrictHostKeyChecking=no \
        -o ConnectTimeout=10 \
        -i ~/.local/share/containers/podman/machine/machine \
        -L "$SOCKET_PATH:/run/user/$(id -u)/podman/podman.sock" \
        -N core@127.0.0.1 -p "$PORT" &

    sleep 3
    if [ -S "$SOCKET_PATH" ]; then
      echo "Podman socket proxy started successfully after machine restart"
      echo "Socket available at: $SOCKET_PATH"
    else
      echo "Failed to start podman socket proxy"
      exit 1
    fi
  '';

  podman-socket-stop = pkgs.writeScriptBin "podman-socket-stop" ''
    #!${pkgs.bash}/bin/bash

    echo "Stopping podman socket proxy..."

    # Kill SSH processes
    pkill -f "ssh.*podman.sock" || true

    # Clean up socket file
    rm -f /tmp/podman.sock

    # Clean up SSH control sockets
    rm -f /tmp/podman-ssh-control-*

    echo "Podman socket proxy stopped"
  '';

  podman-socket-restart = pkgs.writeScriptBin "podman-socket-restart" ''
    #!${pkgs.bash}/bin/bash

    echo "Restarting podman socket proxy..."
    ${podman-socket-stop}/bin/podman-socket-stop
    sleep 2
    ${podman-socket-start}/bin/podman-socket-start
  '';

  podman-socket-status = pkgs.writeScriptBin "podman-socket-status" ''
    #!${pkgs.bash}/bin/bash

    SOCKET_PATH="/tmp/podman.sock"

    echo "=== Podman Socket Status ==="

    # Check if socket file exists
    if [ -S "$SOCKET_PATH" ]; then
      echo "✓ Socket file exists: $SOCKET_PATH"
    else
      echo "✗ Socket file missing: $SOCKET_PATH"
    fi

    # Check SSH processes
    SSH_PROCESSES=$(pgrep -f "ssh.*podman.sock" || echo "")
    if [ -n "$SSH_PROCESSES" ]; then
      echo "✓ SSH tunnel processes running: $SSH_PROCESSES"
    else
      echo "✗ No SSH tunnel processes found"
    fi

    # Check podman machine status
    echo ""
    echo "=== Podman Machine Status ==="
    podman machine list

    # Check podman system connection
    echo ""
    echo "=== Podman System Connections ==="
    podman system connection list

    # Test socket connectivity
    echo ""
    echo "=== Socket Connectivity Test ==="
    if [ -S "$SOCKET_PATH" ]; then
      if timeout 5 podman --remote version >/dev/null 2>&1; then
        echo "✓ Socket is responding to podman commands"
      else
        echo "✗ Socket exists but not responding to podman commands"
      fi
    else
      echo "✗ Cannot test socket - file does not exist"
    fi

    # Environment variables
    echo ""
    echo "=== Environment Variables ==="
    echo "DOCKER_HOST: $DOCKER_HOST"
    echo "TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE: $TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE"
    echo "TESTCONTAINERS_PODMAN_SOCKET_OVERRIDE: $TESTCONTAINERS_PODMAN_SOCKET_OVERRIDE"
    echo "TESTCONTAINERS_RYUK_DISABLED: $TESTCONTAINERS_RYUK_DISABLED"
  '';

  podman-socket-management = pkgs.buildEnv {
    name = "podman-socket-management";
    paths = [
      podman-socket-start
      podman-socket-stop
      podman-socket-restart
      podman-socket-status
    ];
  };

in
{
  # Add podman socket management scripts to home packages
  home.packages = [
    podman-socket-management
  ];

  # Set environment variables for podman/docker compatibility
  home.sessionVariables = {
    DOCKER_HOST = "unix:///tmp/podman.sock";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/tmp/podman.sock";
    TESTCONTAINERS_PODMAN_SOCKET_OVERRIDE = "/tmp/podman.sock";
    TESTCONTAINERS_RYUK_DISABLED = "true";
  };
}

