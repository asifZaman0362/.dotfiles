# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, lib, pkgs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./systemd.nix
      <home-manager/nixos>
    ];


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  networking.firewall = { 
    enable = true;
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedTCPPorts = [ 80 443 24800 8000 ];
    allowedUDPPorts = [ 24800 ];
  };


  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia"
      "nvidia-settings"
      "steam"
      "steam-original"
      "steam-run"
    ];

  # Tell Xorg to use the nvidia driver
  services.xserver.videoDrivers = ["nvidia"];
  services.passSecretService.enable = true;

  hardware.nvidia = {

    # Modesetting is needed for most wayland compositors
    # modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    # open = true;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.forceFullCompositionPipeline = true;
  hardware.nvidia.powerManagement.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = fetchTarball {
        url = "https://github.com/asifZaman0362/dwm/archive/master.tar.gz";
      };
    };
  };

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  services.picom = {
    enable = true;
    settings = {
      blur = {
        method = "dual_kawase";
        strength = 10;
      };
      blurBackgroundExclude = [
          "class_g = 'librewolf'"
          "class_g = 'firefox'"
          "window_type *= 'menu'"
          "name ~= 'Firefox$'"
      ];
    };
    shadowExclude = [
      "window_type *= 'menu'"
      "name ~= 'Firefox$'"
      "focused = 1"
    ];
    vSync = true;
    backend = "glx";
    menuOpacity = 1.0;
  };

  services.geoclue2.enable = true;
  location.provider = "geoclue2";

  services.redshift = {
    enable = true;
    brightness = {
      # Note the string values below.
      day = "1";
      night = "1";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.asif = {
    isNormalUser = true;
    extraGroups = [ "wheel" "adbusers" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
    shell = pkgs.zsh;
  };

  users.users.guest = {
    isNormalUser = true;
  };


  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.zsh.enable = true;
  programs.adb.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    man-pages man-pages-posix stdmanpages
    (st.overrideAttrs (oldAttrs: rec {
      src = fetchTarball {
        url = "https://github.com/asifZaman0362/st-minimal/archive/master.tar.gz";
      };
      # Make sure you include whatever dependencies the fork needs to build properly!
      buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
    # If you want it to be always up to date use fetchTarball instead of fetchFromGitHub
    # src = builtins.fetchTarball {
    #   url = "https://github.com/lukesmithxyz/st/archive/master.tar.gz";
    # };
    }))
    xclip
    killall
    virt-manager
    htop
    git
    curl
    pavucontrol
    clang
    gcc
    cinnamon.nemo-with-extensions
    python3
    dmenu
    home-manager
    feh
    rustup
    mate.mate-polkit
    cmake
    nitrogen
    lxappearance
    scrot jack2 ripgrep
    fd eza bat trash-cli nix-prefetch-git ffmpeg
    rustup imagemagick nil lldb gnumake 
    unzip
  ];

  fonts.packages = with pkgs; [
	(nerdfonts.override { fonts = [ "Hack" "UbuntuMono" "FiraCode" "Iosevka" ]; })
	jetbrains-mono
    fantasque-sans-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  security.polkit.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  documentation.dev.enable = true;
  
  virtualisation.libvirtd.enable = true;
  virtualisation.waydroid.enable = true;
  programs.dconf.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

}

