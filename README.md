# .dotfiles

A repository that contains the `(.)dotfiles` for my `Pop!_OS` setup.

# Usage

```sh
git clone https://github.com/debarchito/.dotfiles.git $HOME
cd .dotfiles
mkdir -p $HOME/.config/nix
ln -sf $HOME/.dotfiles/nix.conf $HOME/.config/nix/nix.conf
ln -sf $HOME/.dotfiles/flake.nix $HOME/.config/nix/flake.nix
ln -sf $HOME/.dotfiles/flake.lock $HOME/.config/nix/flake.lock
home-manager switch --flake .
# Now work how you want from here...
```

# License

[MIT](/LICENSE)
