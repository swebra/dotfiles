{pkgs, ...}: {
  fonts.packages = with pkgs; [
    corefonts #  Arial, Times New Roman, Trebuchet, etc.
    vista-fonts # Calibri
  ];
}
