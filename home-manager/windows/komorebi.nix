{pkgs, ...}: {
  opt.windows.syncPaths = [
    [./komorebi-config/komorebi.jsonc "komorebi.json"]
    [./komorebi-config/komorebi.bar.jsonc "komorebi.bar.json"]
  ];

  home.packages = [
    (pkgs.writeShellScriptBin
      "komorebi-update-app-config"
      "komorebic.exe fetch-app-specific-configuration")
  ];
}
