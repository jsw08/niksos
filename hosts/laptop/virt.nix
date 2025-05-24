{
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["jsw"];

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    podman.enable = true;
  };
}
