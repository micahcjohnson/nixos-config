_default:
  @just --list

# update flake inputs and commit
update:
  nix flake update && jj commit -m 'flake: update inputs'

# shared logic for switch/boot: only tags if a new generation was actually created
_generation-tracked-nh mode *ARGS:
  #!/usr/bin/env bash
  set -euo pipefail
  before=$(nixos-rebuild list-generations --json | jq -r '.[0].generation')
  nh os {{mode}} {{ARGS}}
  after=$(nixos-rebuild list-generations --json | jq -r '.[0].generation')
  if [ "$after" != "$before" ]; then
      jj tag set "$(hostname)-$after" -r 'heads(ancestors(@) & ~empty())'
  fi

# build and activate the new configuration, and make it the boot default
switch *ARGS:
  just _generation-tracked-nh switch {{ARGS}}

# build the new configuration and make it the boot default
boot *ARGS:
  just _generation-tracked-nh boot {{ARGS}}

# build the new configuration only (no activation, no tagging)
build *ARGS:
  nh os build {{ARGS}}
