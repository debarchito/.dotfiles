#!usr/bin/bash
# NOTE: This script assumes it's being run in a fresh Pop!_OS COSMIC installation!

# native
sudo apt update
sudo apt upgrade
sudo apt install extrepo
sudo extrepo enable librewolf
sudo extrepo enable brave_release
curl https://gitlab.com/volian/volian-archive/-/raw/main/install-nala.sh | bash
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
if [ $? -ne 0 ]; then
  echo "[?] Error installing nala using install-nala.sh script. Trying to install it using apt..."
  sudo apt install -t nala nala
fi
sudo nala update
sudo nala install librewolf brave-browser wezterm

# flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak remote-add --if-not-exists --user launcher.moe https://gol.launcher.moe/gol.launcher.moe.flatpakrepo

# nix (Determinate Systems)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
if [ $? -eq 0 ]; then
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && \
  nix-channel --update && \
  nix-shell '<home-manager>' -A install && \
  home-manager switch --flake . --show-trace && \
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
