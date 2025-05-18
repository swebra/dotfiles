# Managing Windows dotfiles with home-manager + WSL
## How it works
[`sync-windows-dotfiles.nix`](./sync-windows-dotfiles.nix) defines a `myHome.windows.syncPaths` option, and an activation script consuming said option. Source-destination path pairs specified in `myHome.windows.syncPaths` are used to generate `rsync` expressions that when evaluated on home-manager activation, copy files from within WSL to a location in the Windows user directory (`C:\Users\username`). The copied files can be from this repo, the nix store, or home-manager-generated files in the Linux home directory.

Note this breaks reproducibility by allowing interaction with files not copied to the store, and creating non-symlink files not in the store.

## Dependencies
1. A WSL instance with nix and home-manager installed
1. A set `$USERPROFILE` environment variable available within the WSL instance
    - The Windows value can be passed through to WSL by adding `USERPROFILE/up` to the Windows `WSLENV` environment variable, see [WSL docs](https://devblogs.microsoft.com/commandline/share-environment-vars-between-wsl-and-windows/) for more details

## Important behavior limitations
1. Any given source file is not guaranteed to exist.
1. This can and will overwrite existing files at the destination path, backup your files first.
1. This will not delete previously-managed-destination files, leftover files have to be cleaned manually.
1. This attempts to make the destination Windows files read-only to discourage their modification (which will be lost in subsequent copies), but the exact behaviour depends on the WSL metadata mount option. See [WSL docs](https://learn.microsoft.com/en-us/windows/wsl/file-permissions) for more details.

## Generated configuration without installing packages
It may be desirable to use home-manager program options to generate dotfiles for applications installed Windows-side without also installing those applications within WSL. In such a case, you can [override the `package` option to `pkgs.emptyDirectory`](https://github.com/nix-community/home-manager/issues/4763#issuecomment-1986996921):
```nix
# Generate git config file without installing git
programs.git = {
  enable = true;
  package = pkgs.emptyDirectory;

  userName = "username";
  userEmail = "user@domain.com";
};
```

## Alternative Windows dotfile management approaches
Rather than a copy-based approach like what is used here, it's actually possible to create Windows symlinks into the WSL file structure by using the `\\wsl$\<name of wsl distribution>` syntax as the destination. In Powershell this would look something like the following ([source](https://stackoverflow.com/a/76181147)):
```powershell
New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\test.json -Target \\wsl$\NixOS/home/eric/test.json
```
The main rub here is the that creating symlinks in Windows requires Administrator access or Developer Mode to be enabled. Admin access can be prompted for from a non-admin shell, including from WSL ([source](https://stackoverflow.com/a/78500345)):
```bash
#!/usr/bin/env bash
ps_command='New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\test.json -Target \\wsl$\NixOS/home/eric/test.json'

# powershell.exe $ps_command
powershell.exe -Command "Start-Process PowerShell -Verb RunAs -ArgumentList '$ps_command'"
```
... but fundamentally I'm only using Windows when I'm forced to for work, and in that case having admin privileges is not guaranteed.
