# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # include hardware scan results
      ./hardware-configuration.nix
    ];

  # bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true; 

  # basic nix configs
  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  nix.gc.automatic = true;

  # networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.hostName = "nixos"; 

  # Set locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # set fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack      
    noto-fonts
    noto-fonts-cjk-sans
  ];
    
  # define user account (set a password with ‘passwd’)
  users.users.witch = {
    isNormalUser = true;
    description = "Witch";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    	# none
    ];
  };

  # enable GNOME DE
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-console
    gnome-calendar
    gnome-weather
    gnome-tour
    gnome-music
    gnome-maps
    gnome-contacts
    gnome-logs
    gnome-photos
    gnome-connections
    cheese
    eog
    simple-scan
    totem
    yelp
    geary
    loupe
    showtime
    decibels
    epiphany
  ];

  # pipewire sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };
  
  # bash aliases
  programs.bash = {
    enable = true;
    shellAliases = {
      v = "nvim";
      sv = "sudo nvim";
      rebuild = "sudo nixos-rebuild switch --upgrade";
      prune = "sudo nix-env --profile ... --delete-generations +2";
    };
  };

  # neovim setup 
  programs.neovim = {
    enable = true;
    configure = {
      customRC = ''
        " 
	set number
	set relativenumber
	set expandtab
	set wrap
	set ruler
	set cursorline
	set smartcase
	set ignorecase
	set mouse=nvi
	set noswapfile
	colorscheme retrobox
	autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
        " ...
      '';
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [ nerdtree ];
      };
    };
  };

  # remaining program options
  programs.firefox.enable = true;
  programs.thunderbird.enable = true;
  programs.steam.enable = true; 

  # remaining program pkgs
  environment.systemPackages = with pkgs; [
    # terminal stuff
    man
    kitty
    fastfetch
    # DE 
    thunderbird
    libreoffice-fresh
    telegram-desktop
    # multimedia
    kdePackages.gwenview
    vlc
    gimp
    virtualbox
    obs-studio
    linuxKernel.packages.linux_zen.v4l2loopback
    # security
    fail2ban
    # python
    (python3.withPackages (python-pkgs: with python-pkgs; [
      matplotlib
      streamlit
      requests
      datetime
      seaborn
      mpmath
      plotly
      pandas
      scipy
      numpy
      dash
      # math
      # json
      # re
    ]))
  ];

  # enable services
  services.fail2ban.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
