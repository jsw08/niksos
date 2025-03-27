{
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["jsw"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.podman.enable = true;
}
