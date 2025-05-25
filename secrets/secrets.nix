let
  jswLaptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHB3qkRCskSMiAs2kLTsG+ruESK4h1pP1FHm+rVnKWx4";
  jswLapserv = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOx/ic0gwhQGpUnlQbpnW5TisPXV9TQgNz6JrQ/vjhaL";

  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZebJtRg3+dZYDGOw7dyjHL69i4MTFdoQEeHlW/AsDu";
  lapserv = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICyy+Tvkelrghc3Vftq8aTnUckec9BV8Ba8XAKCDc+Uw ";

  systems = [laptop lapserv jswLaptop jswLapserv];
in {
  "transfer-sh.age".publicKeys = systems;
  "password.age".publicKeys = systems;
  "dcbot.age".publicKeys = systems;
  "matrix-registration.age".publicKeys = systems;
}
