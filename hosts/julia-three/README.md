# System-specific notes:
## Remote deploy
- Working:
    ```shell
    nixos-rebuild --flake .#julia-three --target-host julia-three --build-host julia-three --use-remote-sudo switch
    ```
- "Equivalent" nh command (which isn't quite equivalent: [1](https://github.com/nix-community/nh/issues/308), [2](https://github.com/nix-community/nh/issues/428)):
    ```shell
    nh os switch --target-host julia-three --build-host julia-three
    ```
- Building locally runs into permission issues because of "trusted users"

## Components not handled in Nix (manually setup and not reproducible)
- SSH keys
- Caddy env file w/ cloudflare tokens


# Notes:
- Disabled certbot on old server with
    ```shell
    sudo snap stop --disable certbot.renew
    ```
