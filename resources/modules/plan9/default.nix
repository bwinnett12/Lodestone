# resources/modules/plan9/default.nix
# Simply importing plan 9
{ inputs, self, ... }: {

	imports = [
    ./u9fs-client.nix
    ./u9fs-server.nix
	];

    # ── Plan 9 permissions user ───────────────────────────────────────────────
    users = { 
      users.u9fs = {
        isSystemUser = true;
        group        = "u9fs";
        description  = "u9fs 9P file server user";
      };
    groups.u9fs = {};
    };

    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 4500 ];
}