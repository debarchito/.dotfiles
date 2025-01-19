#!/usr/bin/bash

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
if [ $? -eq 0 ]; then
  export NIX=/nix/var/nix/profiles/default/bin/nix
  export NIXPKGS_ALLOW_UNFREE=1
  exec $NIX run home-manager/master -- switch --flake . --impure --show-trace
  sudo $NIX run 'github:numtide/system-manager' -- switch --flake .
  sudo $(pwd)/result/bin/activate
  if [ $? -ne 0 ]; then
    echo "[!] Error installing home-manager or system-manager. Try running the commands manually."
    exit 1
  fi
  sudo groupadd docker
  sudo usermod -aG docker $USER
else
  echo "[!] Error installing nix. Try running the commands manually."
  exit 1
fi
