# Remote deploy
```shell
nh os switch --target-host julia-three --build-host julia-three
```

Rough nixos-rebuild equivalent:
```shell
nixos-rebuild --flake .#julia-three --target-host julia-three --build-host julia-three --sudo --ask-sudo-password switch
```

Building locally runs into permission issues because of "trusted users"

# Notes:
- Disabled certbot on old server with
    ```shell
    sudo snap stop --disable certbot.renew
    ```
