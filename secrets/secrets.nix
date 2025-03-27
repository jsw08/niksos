let
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHB3qkRCskSMiAs2kLTsG+ruESK4h1pP1FHm+rVnKWx4";

  systems = [laptop];
in {
  "transfer-sh.age".publicKeys = systems;
  "password.age".publicKeys = systems;
}
