{ lib, pkgs, config, ... }:

with lib;

let
  guacVer = "1.6.0";
  guacd = pkgs.stdenv.mkDerivation rec {
    pname = "guacd";
    version = guacVer;
    src = pkgs.fetchurl {
      url = "https://downloads.apache.org/guacamole/${guacVer}/source/guacamole-server-${guacVer}.tar.gz";
      # replace with actual sha256 when adding to your flake
      sha256 = "0000000000000000000000000000000000000000000000000000";
    };
    nativeBuildInputs = [ pkgs.autoconf pkgs.automake pkgs.libtool pkgs.pkg-config pkgs.gnumake pkgs.gcc ];
    buildInputs = [ pkgs.openssl pkgs.libpng pkgs.libssh2 pkgs.libjpeg-turbo pkgs.zlib ];
    unpackPhase = "tar xzf $src --strip-components=1";
    configurePhase = ''
      ./configure --prefix=$out
    '';
    buildPhase = "make";
    installPhase = "make install DESTDIR=$out";
  };

  guacamoleClientWar = pkgs.fetchurl {
    url = "https://downloads.apache.org/guacamole/${guacVer}/binary/guacamole-${guacVer}.war";
    sha256 = "0000000000000000000000000000000000000000000000000000"; # replace
  };
in

{
  options.services.guacamole = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Apache Guacamole (guacd + Tomcat + Guacamole webapp).";
    };
    httpPort = mkOption {
      type = types.port;
      default = 8080;
      description = "Port for Guacamole web UI (Tomcat).";
    };
    guacdPort = mkOption {
      type = types.port;
      default = 4822;
      description = "Port for guacd.";
    };
    guacamoleWar = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Optional path to a local guacamole .war; if null the module fetches upstream.";
    };
  };

  config = mkIf config.services.guacamole.enable (let
    warPath = if config.services.guacamole.guacamoleWar == null then guacamoleClientWar else config.services.guacamole.guacamoleWar;
  in {
    environment.systemPackages = [ guacd pkgs.tomcat pkgs.openjdk ];

    systemd.services.guacd = {
      description = "Apache Guacamole daemon (guacd)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${guacd}/sbin/guacd -f -L ${toString config.services.guacamole.guacdPort}";
        Restart = "on-failure";
        User = "root";
      };
    };

    systemd.services.guacamole-deploy = {
      description = "Deploy Guacamole WAR to Tomcat webapps";
      after = [ "network.target" "tomcat.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          mkdir -p /var/lib/tomcat/webapps
          cp ${warPath} /var/lib/tomcat/webapps/guacamole.war
        '';
      };
    };

    # Tomcat override: set GUACAMOLE_HOME and run Tomcat on chosen port
    systemd.services.tomcat = {
      serviceConfig = {
        Environment = lib.concatStringsSep " " [
          "GUACAMOLE_HOME=/etc/guacamole"
          "JAVA_HOME=${pkgs.jre}/lib/jvm"
        ];
        ExecStart = "${pkgs.tomcat}/bin/catalina.sh run";
        Restart = "always";
        User = "root";
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    };

    # Minimal Guacamole config (guacamole.properties + user-mapping example)
    environment.etc."guacamole/guacamole.properties".text = ''
      guacd-hostname: 127.0.0.1
      guacd-port: ${toString config.services.guacamole.guacdPort}
    '';

    environment.etc."guacamole/user-mapping.xml".text = ''
      <user-mapping>
        <authorize username="user" password="password">
          <connection name="local-vnc">
            <protocol>vnc</protocol>
            <param name="hostname">127.0.0.1</param>
            <param name="port">5901</param>
          </connection>
        </authorize>
      </user-mapping>
    '';

    system.activationScripts.guacamole-activate.text = ''
      mkdir -p /etc/guacamole
      chmod 755 /etc/guacamole
    '';

    # Firewall: allow only local/LAN HTTP; recommend relying on Tailscale for remote access.
    networking.firewall.allowedTCPPorts = lib.mkIf true [ config.services.guacamole.httpPort ];
  }));
}
