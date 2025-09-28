# System-specific notes:
## Remote deploy
- Working:
    ```shell
    nixos-rebuild --flake .#julia-three --target-host julia-three --build-host julia-three --use-remote-sudo switch
    ```
- "Equivalent" nh command (which isn't [actually building locally](https://github.com/nix-community/nh/issues/308)):
    ```shell
    nh os switch --target-host julia-three --build-host julia-three
    ```
- Building locally runs into permission issues because of "trusted users"

## Components not handled in Nix (manually setup and not reproducible)
- SSH keys


# TODO:
- Caddy cloudflare plugin
