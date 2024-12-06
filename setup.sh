#!usr/bin/bash
# NOTE: This script assumes it's being run in a fresh Pop!_OS COSMIC installation!

# apt, extrepo, nala
sudo apt update
sudo apt upgrade
sudo apt install extrepo
sudo extrepo enable librewolf
sudo extrepo enable brave_release
curl https://gitlab.com/volian/volian-archive/-/raw/main/install-nala.sh | bash
if [ $? -ne 0 ]; then
  echo "[?] Error installing nala using install-nala.sh script. Trying to install it using apt..."
  sudo apt install -t nala nala
fi

# flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak remote-add --if-not-exists --user launcher.moe https://gol.launcher.moe/gol.launcher.moe.flatpakrepo

# nix (Determinate Systems), home-manager
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
if [ $? -eq 0 ]; then
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
else
  echo "[?] Error installing nix. Skipping home-manager installation. You need to install it manually."
  echo "[?] Exiting early."
  exit 1
fi
