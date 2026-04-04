## 1. Setup

Apply the NixOS configuration using:

```fish
sudo nixos-rebuild switch --flake .#<host>
```

This will enable the [nh](https://github.com/nix-community/nh) utility. Thus,
subsequent applications can be triggered using:

```fish
nh os switch -c <host>
# or, just:
nh os switch
```

Apply the Home-Manager configuration using:

```fish
home-manager switch --flake .#<user>@<host>
# or:
nh home switch -c <user>@<host>
```

Lastly, run the setup script to apply all the impure adjustments:

```fish
nix run .#impure-setup
```

## 2. Templates

This repo also contains a templating engine alongside tailored development
templates. Get started using:

```fish
nix run github:debarchito/.dotfiles#generate
```

Initialize a template (e.g Rust) using:

```fish
nix run github:debarchito/.dotfiles#generate rust ./hello-world name=hello-world description="Say hello to the world!"
```

The run using:

```fish
nix run ./hello-world
```

## 3. Licensing

The repository is licensed under the [zlib](/LICENSE) license.
