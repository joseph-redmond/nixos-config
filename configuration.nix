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
    pkgs.neovim
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.server_maintainer = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB5QGHV/56stPL+hZiyWsjMyUfkvUi4PfRRf2+2VC0D josephredmondjr@Josephs-Mini.lan"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB5QGHV/56stPL+hZiyWsjMyUfkvUi4PfRRf2+2VC0D josephredmondjr@Josephs-Mini.lan"
  ];

  system.stateVersion = "24.11";

  system.autoUpgrade = {
    enable = true;
    dates = "15:30";
    flake = "github:jredmondjr/nixos-config#hc001";
    flags = ["--refresh"];
    randomizedDelaySec = "5m";
  };
}
