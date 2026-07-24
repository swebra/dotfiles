{pkgs, ...}: {
  programs.vscode.profiles.default.extensions = with pkgs.vscode-marketplace-release; [
    tomoki1207.pdf
    sandcastle.vscode-open
    nefrob.vscode-just-syntax
  ];

  home.packages = [pkgs.just-lsp];
}
