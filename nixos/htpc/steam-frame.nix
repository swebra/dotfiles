{pkgs, ...}: {
  /*
  - https://wiki.nixos.org/wiki/Steam_Frame
  - https://wiki.nixos.org/wiki/Steam
  - https://wiki.nixos.org/wiki/VR#SteamVR

  Bunch of copied config to make the wireless adapter work.
  */
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom=CA
  '';
  hardware.enableRedistributableFirmware = true;
  environment.systemPackages = [pkgs.iw];
  users.users.eric.extraGroups = ["networkmanager"];
}
