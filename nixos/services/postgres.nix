{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    opt.postgres.enable = lib.mkEnableOption "Enables postgres support";
  };

  config = lib.mkIf config.opt.postgres.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      extensions = ps: with ps; [postgis pg_repack];

      initialScript = pkgs.writeText "init-sql-script" ''
        alter user postgres with password 'postgres';
      '';
    };
  };
}
