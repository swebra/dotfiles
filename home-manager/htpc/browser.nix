{config, ...}: {
  # Not using zen as it always inherits the previous window size and does not support
  # --width/--height options. No fullscreen from the CLI either.

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox"; # Modern location

    policies = {
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      SkipTermsOfUse = true;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
      };
      DisplayBookmarksToolbar = "never";

      ExtensionSettings = let
        moz = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
      in {
        "uBlock0@raymondhill.net" = {
          install_url = moz "ublock-origin";
          installation_mode = "normal_installed";
          private_browsing = true;
        };
      };
    };

    profiles.default = {
      settings = {
        # Configure firefox for Steam usage as per
        # https://www.reddit.com/r/SteamDeck/comments/16eiyi6/make_firefox_work_better_in_game_mode/
        # Wayland mode is now default, does not need to be specified

        # Fullscreen fix in gamescope
        "full-screen-api.ignore-widgets" = true;
        # Don't restore after exiting through Steam
        "browser.sessionstore.resume_from_crash" = false;
      };

      # TODO: Add bookmarks
      # TODO: Add start page
    };
  };

  myHome.gaming.emulation.manifests.firefox = {
    target = "firefox";
    launchOptions = "--width 1920 --height 1080";
  };
}
