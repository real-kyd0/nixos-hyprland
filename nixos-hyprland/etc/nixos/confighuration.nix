{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/network.nix
      ./modules/sound.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.kyd0 = {
    isNormalUser = true;
    description = "Denys";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      git
      htop
      btop
      ranger
      fastfetch
      cava
      wget
      unzip
      python3
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      pkgs.intel-media-driver
      pkgs.vulkan-tools
      pkgs.libvdpau-va-gl
    ];
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
	user = "kyd0";
      };
      default_session = initial_session;
    };
  };

  services.xserver.enable = false;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  programs.nix-ld.enable = true;
  programs.zsh = {
    enable = true;

    shellAliases = {
      hy = "sudo nvim $HOME/.config/hypr/hyprland.conf";
      nx = "sudo nvim /etc/nixos/configuration.nix";
      rb = "sudo nixos-rebuild switch";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    foot
    hyprpaper
    wofi
    waybar
    chromium
    firefox
    kotatogram-desktop
    bibata-cursors
    libreoffice
    discord
    grim
    shotcut
    mpv
    mpd
    wf-recorder
    jdk21
    openssh
    mesa
    gcc
    grim
    slurp
    zed-editor
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    font-awesome
  ];

  services.tlp.enable = true;

  nix.settings.experimental-features = [ "nix-command"  "flakes" ];

  system.stateVersion = "25.11";

}
