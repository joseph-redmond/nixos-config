{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  console.keyMap = "dvorak";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  services.openssh = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.emacs
    pkgs.wget
    pkgs.gitMinimal
    pkgs.htop
  ];

  users.users.server_maintainer = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "";
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILDKz72DT4nCg2713iHRc8UgLNcpu6nLcJkeXuol2eB8AAAABHNzaDo="
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILDKz72DT4nCg2713iHRc8UgLNcpu6nLcJkeXuol2eB8AAAABHNzaDo="
  ];

  system.stateVersion = "24.11";

  services.caddy = {
    enable = true;
    virtualHosts."josephredmond.com".extraConfig = ''
      reverse_proxy http://localhost:8080
    ''
  };

  networking.firewall.allowedTCPPorts = [ 80 443];


  services.wordpress.webserver = "caddy";
  services.wordpress.sites."josephredmond.com" = {
    database.createLocally = true;  # name is set to `wordpress` by default
    virtualHost = {
      adminAddr = "admin@josephredmond.com";
      serverAliases = [ "josephredmond.com" ];
    };
  };

  system.autoUpgrade = {
    enable = true;
    dates = "hourly";
    flake = "github:joseph-redmond/nixos-config#hc001-wordpress";
    flags = ["--refresh"];
    randomizedDelaySec = "5m";
    allowReboot = true;
  };

  boot.loader.systemd-boot.configurationLimit = 10;
}
