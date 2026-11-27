{pkgs, ...}: {
  xdg.configFile."luciole/config.toml".source = (pkgs.formats.toml {}).generate "luciole-config" {
    browser = {
      # Behavior
      expandable_folders = true;
      single_click_location_edit = true;
      switch_to_new_tab = false;
      remember_folder_views = true; # View is per-folder instead of global
      typing_mode = "filter";

      # File picker behavior
      chooser_start_folder = "last";
      chooser_show_preview = false;

      # Ordering
      directories_first = true;
      show_hidden = true;
      hidden_last = true;

      # Visual
      always_show_tab_bar = false;
      show_sidebar_button = false;
      operations_button = "busy"; # Only if there's an on-going operation
    };
  };

  xdg.dataFile."luciole/scripts/Send via KDE Connect" = let
    script = pkgs.writeShellScript "share-via-kdeconnect" ''
      DEVICE=$(kdeconnect-cli --list-available --name-only | noctalia dmenu -p "Send to device...")
      [ -z "$DEVICE" ] && exit 0  # Exit if cancelled

      for file in "$@"; do
        kdeconnect-cli --name "$DEVICE" --share "$file"
      done
    '';
  in {
    source = script;
    executable = true;
  };
}
