{...}: {
  # Support typical (non-nix) dynamically-linked executables
  # Needed for things like precompiled Python packages (ruff, numpy, etc.)
  programs.nix-ld.enable = true;
}
