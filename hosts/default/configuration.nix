{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true; 	

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "feather"; 
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  services.libinput.enable = false;
  fonts.fontconfig.enable = true;

  users.users.mschewe = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ]; 
    packages = with pkgs; [
       google-chrome
    ];
  };
  
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "mschewe" = import ./home.nix;
    };
  };

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    neovim
    networkmanagerapplet
    vim 
    waybar
    wget
    wofi
    jetbrains.goland
    git
  ];


  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-emoji
  ];

  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


  services.openssh.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;

  # system.copySystemConfiguration = true;

  system.stateVersion = "24.05"; # Did you read the comment?


  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };


  services.greetd = {                                                      
    enable = true;                                                         
    settings = {                                                           
      default_session = {                                                  
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd hyprland";
        user = "mschewe";                                                  
      };                                                                   
      initial_session = {
        command = "hyprland";
        user = "mschewe";
      };
    };                                                                     
  };

  programs.light.enable = true;
}

