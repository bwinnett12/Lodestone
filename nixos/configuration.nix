{ config, pkgs, lib, ... }: # Added 'lib' for potentially useful functions later

{
  imports = [
    # ESSENTIAL: Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Crucial for flakes to work
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define system state version - align with actual channel or unstable (master)
  system.stateVersion = "24.11"; # Set this to the *current unstable* version for master branch consistency

  # --- Bootloader: Use systemd-boot ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Ensure GRUB is explicitly disabled if it tries to creep in (unlikely but good for debugging)
  boot.loader.grub.enable = lib.mkForce false; # FORCE DISABLE GRUB

  # --- Networking ---
  networking.hostName = "Loom";
  networking.networkmanager.enable = true; # Use NetworkManager

  # --- Time Zone ---
  time.timeZone = "America/Anchorage";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Audio (PipeWire) ---
  security.rtkit.enable = true;
  # sound.enable is removed
  hardware.pulseaudio.enable = false; # Explicitly disable legacy PulseAudio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- X Server & GNOME ---
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # --- Users ---
  users.groups.users = {}; # Define the 'users' group

  users.users.tarobutter = {
    isNormalUser = true; # THIS MUST BE TRUE
    description = "tarobutter";
    group = "users";     # THIS MUST BE "users"
    extraGroups = [ "wheel" "networkmanager" ]; # Add any other groups you need
    # Omit 'packages' for now to keep it minimal
    # If you need a password set: password = "your-actual-hash-here";
  };

  # --- Unfree Packages ---
  nixpkgs.config.allowUnfree = true;

  # --- System Packages (minimal for now) ---
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # For your Surface hardware (ensure nixos-hardware input is in flake.nix)
  # This line is handled in flake.nix's modules section, so it's not needed here.
  # nixos-hardware.nixosModules.microsoft-surface-book2;
  # ^ DO NOT PUT IT HERE. It's in your flake.nix already.
}
