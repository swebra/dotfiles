{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    extensions = ps: with ps; [postgis pg_repack];

    initialScript = pkgs.writeText "init-sql-script" ''
      alter user postgres with password 'postgres';
    '';
  };
}
