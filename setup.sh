#!/usr/bin/bash

nix run home-manager/master -- switch --flake . --impure --show-trace
sudo $(which nix) run 'github:numtide/system-manager' -- switch --flake .
sudo $(pwd)/result/bin/activate

if [ $? -ne 0 ]; then
  echo "[!] Error setting up home-manager or system-manager. Try running the commands manually."
  exit 1
fi

sudo groupadd docker
sudo usermod -aG docker $USER
