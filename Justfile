set shell := ["fish", "-c"]

default:
  @just --list

home-switch:
  home-manager switch --flake . --show-trace

system-switch:
  sudo (which nix) run 'github:numtide/system-manager' -- switch --flake '.'
