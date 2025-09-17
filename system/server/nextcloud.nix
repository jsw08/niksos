{
  config,
  pkgs,
  lib,
  ...
}: let
  name = "nextcloud";
  cfg = import ./lib/extractWebOptions.nix {inherit config name;};

  inherit (cfg) enable domain;

  nginxRoot = config.services.nginx.virtualHosts.${domain}.root;
  fpmSocket = config.services.phpfpm.pools.nextcloud.socket;
  imaginaryPort = 9004;
in {
  options = import ./lib/webOptions.nix {inherit config lib name;};

  config = lib.mkIf enable {
    users.groups.nextcloud.members = ["nextcloud" "caddy"];

    services = {
      nextcloud = {
        enable = true;
        hostName = domain;

        # Need to manually increment with every major upgrade.
        package = pkgs.nextcloud31;

        database.createLocally = true;
        configureRedis = true;

        maxUploadSize = "16G";
        https = true;

        autoUpdateApps.enable = true;
        extraAppsEnable = true;
        extraApps = {
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
          inherit
            (config.services.nextcloud.package.packages.apps)
            calendar
            contacts
            mail
            user_oidc
            phonetrack
            ;
          external = pkgs.fetchNextcloudApp {
            # https://github.com/helsinki-systems/nc4nix/blob/main/31.json #NOTE: 31.json is version.
            hash = "sha256-xVrnahqgXIXjk9gukrFgpwZiT2poUIDl83xV8hXPisw=";
            url = "https://github.com/nextcloud-releases/external/releases/download/v6.0.2/external-v6.0.2.tar.gz";
            license = "agpl3Plus";
          };
        };

        settings = {
          "auth.webauthn.enabled" = false; #INFO: We use openid baby...
          default_phone_region = "NL";
          enabledPreviewProviders = [
            "OC\\Preview\\BMP"
            "OC\\Preview\\GIF"
            "OC\\Preview\\JPEG"
            "OC\\Preview\\Krita"
            "OC\\Preview\\MarkDown"
            "OC\\Preview\\MP3"
            "OC\\Preview\\OpenDocument"
            "OC\\Preview\\PNG"
            "OC\\Preview\\TXT"
            "OC\\Preview\\XBitmap"
            "OC\\Preview\\HEIC"
            "OC\Preview\Imaginary"
          ];
          preview_imaginary_url = "http://localhost:${builtins.toString imaginaryPort}";
          preview_format = "webp";

          trusted_proxies = ["127.0.0.1"];
          maintenance_window_start = 1;
          log_type = "file";
        };
        phpOptions."opcache.interned_strings_buffer" = 24;
        config = {
          adminuser = "jsw-admin";
          adminpassFile = "${config.age.secrets.nextcloud-admin-pass.path}";
          dbtype = "pgsql";
        };
      };
      # imaginary = { #FIXME: doesn't start.
      #   enable = true;
      #   port = imaginaryPort;
      #   address = "localhost";
      #   settings.returnSize = true;
      # };

      nginx.enable = lib.mkForce false;
      phpfpm.pools.nextcloud.settings = let
        inherit (config.services.caddy) user group;
      in {
        "listen.owner" = user;
        "listen.group" = group;
      };

      caddy = {
        enable = true;
        virtualHosts.${domain}.extraConfig = ''
          encode zstd gzip

          root * ${nginxRoot}

          redir /.well-known/carddav /remote.php/dav 301
          redir /.well-known/caldav /remote.php/dav 301
          redir /.well-known/* /index.php{uri} 301
          redir /remote/* /remote.php{uri} 301

          header {
            Strict-Transport-Security max-age=31536000
            Permissions-Policy interest-cohort=()
            X-Content-Type-Options nosniff
            X-Frame-Options SAMEORIGIN
            Referrer-Policy no-referrer
            X-XSS-Protection "1; mode=block"
            X-Permitted-Cross-Domain-Policies none
            X-Robots-Tag "noindex, nofollow"
            -X-Powered-By
          }

          php_fastcgi unix/${fpmSocket} {
            root ${nginxRoot}
            env front_controller_active true
            env modHeadersAvailable true
          }

          @forbidden {
            path /build/* /tests/* /config/* /lib/* /3rdparty/* /templates/* /data/*
            path /.* /autotest* /occ* /issue* /indie* /db_* /console*
            not path /.well-known/*
          }
          error @forbidden 404

          @immutable {
            path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
            query v=*
          }
          header @immutable Cache-Control "max-age=15778463, immutable"

          @static {
            path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
            not query v=*
          }
          header @static Cache-Control "max-age=15778463"

          @woff2 path *.woff2
          header @woff2 Cache-Control "max-age=604800"

          file_server
        '';
      };
    };
  };
}
