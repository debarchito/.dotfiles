#!usr/bin/bash

# nix (Determinate Systems)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
if [ $? -eq 0 ]; then
  export NIXPKGS_ALLOW_UNFREE=1
  nix run home-manager/master -- switch --flake . --impure --show-trace && \
  sudo $(which nix) run 'github:numtide/system-manager' -- switch --flake . && \
  sudo $(pwd)/result/bin/activate
  if [ $? -ne 0 ]; then
    echo "[?] Error installing home-manager or system-manager. Try running the commands manually."
    exit 1
  fi
else
  echo "[?] Error installing nix. Try running the commands manually."
  exit 1
fi
