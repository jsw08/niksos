let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHB3qkRCskSMiAs2kLTsG+ruESK4h1pP1FHm+rVnKWx4" # jsw@laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOx/ic0gwhQGpUnlQbpnW5TisPXV9TQgNz6JrQ/vjhaL" # jsw@lapserv
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/WnwVZAUEC/mi7OxhGRXIMASHVj9t8Jbo06xa+NsjG" # jsw@desktop
  ];

  devices = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZebJtRg3+dZYDGOw7dyjHL69i4MTFdoQEeHlW/AsDu" # laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICyy+Tvkelrghc3Vftq8aTnUckec9BV8Ba8XAKCDc+Uw " # lapserv
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBBwuisiDr/WiZ4Q/HUIiPORiC8Ik47+qRvB0SL3enf" # desktop
  ];

  keys = users ++ devices;
in {
  "password.age".publicKeys = keys;
  "dcbot.age".publicKeys = keys;
  "bread-dcbot.age".publicKeys = keys;
  "matrix-registration.age".publicKeys = keys;
  "mail-admin.age".publicKeys = keys;
  "zitadel-key.age".publicKeys = keys;
  "forgejo-mailpass.age".publicKeys = keys;
  "immich-oidc.age".publicKeys = keys;
  "nextcloud-admin-pass.age".publicKeys = keys;
}
