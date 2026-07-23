{ pkgs, lib, ... }: {
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/outputs".text = ''
    ({"card1-eDP-1": (
      enabled: true,
      mode: Some((
        size: (w: 1920, h: 1280),
        refresh: Some(60000),
      )),
      scale: 1.5,
      transform: Normal,
      vrr: false,
      max_active_hint: false,
    )})
  '';
}