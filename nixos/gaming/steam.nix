{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.opt.gaming.enable {
    programs.steam = {
      enable = true;

      # Firewall ports
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      extraCompatPackages = with pkgs; [
        # For Halo MCC co-op
        proton-ge-bin
      ];
    };
  };
}
