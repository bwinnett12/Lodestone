# resources/modules/power/cosmic-ppd-shim.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.ecosystem.power;

  ppdShim = pkgs.writeText "ppd-shim.py" ''
    import asyncio
    import subprocess
    from dbus_next.aio import MessageBus
    from dbus_next.service import ServiceInterface, method, dbus_property
    from dbus_next import Variant, PropertyAccess
    from dbus_next.constants import BusType

    PROFILE_MAP = {
        "power-saver": "profile-barebones",
        "balanced": "profile-balanced",
        "performance": "profile-performance",
    }

    class PowerProfiles(ServiceInterface):
        def __init__(self):
            super().__init__("net.hadess.PowerProfiles")
            self._active = "balanced"

        @dbus_property(access=PropertyAccess.READWRITE)
        def ActiveProfile(self) -> "s":
            return self._active

        @ActiveProfile.setter
        def ActiveProfile(self, value: "s"):
            script = PROFILE_MAP.get(value)
            if script:
                subprocess.run([script])
                self._active = value
                self.emit_properties_changed({"ActiveProfile": value})

        @dbus_property(access=PropertyAccess.READ)
        def Profiles(self) -> "aa{sv}":
            return [{"Profile": Variant("s", p), "Driver": Variant("s", "custom")}
                    for p in PROFILE_MAP]

        @dbus_property(access=PropertyAccess.READ)
        def PerformanceDegraded(self) -> "s":
            return ""

        @dbus_property(access=PropertyAccess.READ)
        def Actions(self) -> "as":
            return []

    async def main():
        bus = await MessageBus(bus_type=BusType.SYSTEM).connect()
        bus.export("/net/hadess/PowerProfiles", PowerProfiles())
        await bus.request_name("net.hadess.PowerProfiles")
        await asyncio.get_event_loop().create_future()

    asyncio.run(main())
  '';

  pythonEnv = pkgs.python3.withPackages (ps: [ ps.dbus-next ]);

in {
  config = lib.mkIf cfg.portable.enable {
    systemd.services.cosmic-ppd-shim = {
      description = "PPD-compatible shim routing COSMIC's power toggle to custom profile scripts";
      wantedBy = [ "multi-user.target" ];
      after = [ "dbus.service" ];
      serviceConfig = {
        ExecStart = "${pythonEnv}/bin/python3 ${ppdShim}";
        Restart = "on-failure";
      };
    };

    # Let dbus-daemon allow this system service to own the name
    services.dbus.packages = [
      (pkgs.writeTextFile {
        name = "net.hadess.PowerProfiles.conf";
        destination = "/etc/dbus-1/system.d/net.hadess.PowerProfiles.conf";
        text = ''
          <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
           "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
          <busconfig>
            <policy user="root">
              <allow own="net.hadess.PowerProfiles"/>
            </policy>
            <policy context="default">
              <allow send_destination="net.hadess.PowerProfiles"/>
              <allow receive_sender="net.hadess.PowerProfiles"/>
            </policy>
          </busconfig>
        '';
      })
    ];
  };
}