# copied from https://github.com/fufexan/dotfiles/blob/main/pkgs/repl/default.nix
{pkgs, ...}: let
  repl = ./lib.nix;
  example = command: desc: ''\n\u001b[33m ${command}\u001b[0m - ${desc}'';
in {
  home.packages = [
    (pkgs.writeShellScriptBin
      "repl"
      ''
        case "$1" in
          "-h"|"--help"|"help")
            printf "%b\n\e[4mUsage\e[0m: \
              ${example "repl" "Loads system flake if available."} \
              ${example "repl /path/to/flake.nix" "Loads specified flake."}\n"
          ;;
          *)
            if [ -z "$1" ]; then
              nix repl ${repl}
            else
              nix repl --arg flakePath $(${pkgs.coreutils}/bin/readlink -f $1 | ${pkgs.gnused}/bin/sed 's|/flake.nix||') ${repl}
            fi
          ;;
        esac
      '')
  ];
}
