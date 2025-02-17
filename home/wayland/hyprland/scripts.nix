{pkgs, ...}: {
  statusnotify = pkgs.writeShellScriptBin "statusnotify" ''
    DATE=$(date +%R)

    upower -e | grep 'BAT' 2>&1 > /dev/null
    if [ $? -eq 0 ]; then
      BAT=$(upower -i $(upower -e | grep 'BAT') | sed -n -e 's/.*time [a-z \s]*: *\([0-9.]* \w*\).*/\1/p' -e 's/.*per\w*: *\([0-9]*%\).*/\1/p' | sed 'N;s/\n/ - /')
      echo "$DATE - $BAT"
    else
      echo $DATE
    fi
  '';
}
