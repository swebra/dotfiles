{...}: {
  # services.jellyfin = {
  #   enable = true;
  # };

  myOS.server.caddy.subdomain."jellyfin" = ''
    reverse_proxy http://192.168.1.100:8096
  '';
}
# TODO:
# - Actually host service here
# - NAS mount
# - Hardware transcoding
# - Ultrachromic theme
#   - https://github.com/matt1432/nixos-jellyfin
#   - https://git.nelim.org/matt1432/nixos-configs/src/commit/29bc56e7492c5d2310016d5aed612a8fb4a5b127/devices/nos/modules/jellyfin/default.nix#L60
# - Backup

