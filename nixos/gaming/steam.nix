{pkgs, ...}: {
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
}
