{...}: let
  tf2Cfg = ".local/share/Steam/steamapps/common/Team Fortress 2/tf/cfg";
in {
  # Launch options
  # -novid -heapsize 4194304 -threads 4

  home.file."${tf2Cfg}/autoexec.cfg".text = ''
    // Performance and Visual Settings //
    // ############################### //
    // fps_max 144
    mat_motion_blur_enabled 0

    // FOV and viewmodels
    fov_desired 90
    viewmodel_fov 70
    tf_use_min_viewmodels 1

    // Network settings, disabled, should be reviewed
    // cl_cmdrate 40
    // cl_updaterate 40
    // cl_interp 0.025
    // cl_interp_ratio 1
    // cl_lagcompensation 1
    // cl_pred_optimize 2
    // cl_smooth 1
    // cl_smoothtime 0.01
    // rate 35000

    // cl_interp of 0.0152

    // cl_cmdrate 67
    // cl_updaterate 67
    // rate 60000
    // cl_interp_ratio 1

    // cl_lagcompensation 1
    // cl_pred_optimize 2
    // cl_smooth 0
    // cl_smoothtime 0.01


    // Audio Settings //
    // ############## //

    // Hitsound settings
    tf_dingaling_pitchmindmg 165
    tf_dingaling_pitchmaxdmg 25


    // Fixes and Options //
    // ################# //

    // Sniper Zoom Fix
    zoom_sensitivity_ratio 0.793471

    // Damage Text
    hud_combattext_batching 1
    hud_combattext_batching_window 2.0


    // ----- Keybinds ----- //
    // #################### //
    unbindall

    // Mouse
    bind "MOUSE1" "+attack"
    bind "MOUSE2" "+attack2"
    bind "mwheelup" "slot1"
    bind "mwheeldown" "slot2"
    bind "mouse4" "slot3"
    bind "MOUSE3" "voicemenu 0 1"
    bind "MOUSE5" "+voicerecord"

    // Keyboard
    bind "i" "explode"
    bind "\" "toggleconsole"

    bind "q" "+use_action_slot_item"
    bind "h" "+attack3"
    // See class specific binds for use of "b" button
    bindtoggle t "r_drawviewmodel"

    bind "UPARROW" "load_itempreset 0"
    bind "LEFTARROW" "load_itempreset 1"
    bind "RIGHTARROW" "load_itempreset 2"
    bind "DOWNARROW" "load_itempreset 3"

    bind "home" "showmapinfo"
    bind "ins" "hud_reloadscheme"

    // Default
    bind "w" "+forward"
    bind "a" "+moveleft"
    bind "s" "+back"
    bind "d" "+moveright"
    bind "SPACE" "+jump"
    bind "SHIFT" "+duck"

    bind "ESCAPE" "cancelselect"
    bind "TAB" "+showscores"
    bind "j" "cl_trigger_first_notification"
    bind "k" "cl_decline_first_notification"

    bind "0" "slot10"
    bind "1" "slot1"
    bind "2" "slot2"
    bind "3" "slot3"
    bind "4" "slot4"
    bind "5" "slot5"
    bind "6" "slot6"
    bind "7" "slot7"
    bind "8" "slot8"
    bind "9" "slot9"

    bind "e" "+helpme"
    bind "r" "+reload"
    bind "f" "+inspect"
    bind "g" "+taunt"
    bind "l" "dropitem"

    bind "," "changeclass"
    bind "." "changeteam"
    bind "m" "open_charinfo_direct"

    bind "y" "say"
    bind "u" "say_team"
    bind "z" "voice_menu_1"
    bind "x" "voice_menu_2"
    bind "c" "voice_menu_3"

    bind "F1" "+showroundinfo"
    bind "F2" "show_quest_log"
    bind "F3" "askconnect_accept"
    bind "F4" "player_ready_toggle"
    bind "F5" "screenshot"
    bind "F6" "save_replay"
    bind "F7" "abuse_report_queue"
    bind "F9" "vr_toggle"
    bind "F10" "quit prompt"
    bind "F12" "replay_togglereplaytips"
  '';

  home.file."${tf2Cfg}/reset.cfg".text = ''
    unbind "b"
  '';

  home.file."${tf2Cfg}/scout.cfg".text = "exec reset.cfg";
  home.file."${tf2Cfg}/soldier.cfg".text = "exec reset.cfg";
  home.file."${tf2Cfg}/pyro.cfg".text = "exec reset.cfg";
  home.file."${tf2Cfg}/demoman.cfg".text = "exec reset.cfg";
  home.file."${tf2Cfg}/heavyweapons.cfg".text = "exec reset.cfg";
  home.file."${tf2Cfg}/engineer.cfg".text = ''
    exec reset.cfg
    bind "b" "destroy 2 0; build 2 0"
  '';
  home.file."${tf2Cfg}/medic.cfg".text = "exec reset.cfg";
  home.file."${tf2Cfg}/sniper.cfg".text = "exec reset.cfg";
  home.file."${tf2Cfg}/spy.cfg".text = ''
    exec reset.cfg
    bind "b" "lastdisguise"
  '';
}
