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
nix develop .#impure-setup --command fish
# inside the development shell, run:
execute-impure-setup
```

## 2. Licensing

The repository is licensed under the [zlib](/LICENSE) license.
