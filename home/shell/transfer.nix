{
  pkgs,
  osConfig,
  ...
}: {
  home.packages = [
    (pkgs.writeShellScriptBin "transfer" ''
      PASSWORD=$(sed 's/.*="\(.*\)"/\1/' ${osConfig.age.secrets.transferSh.path})


      if [ -z "$PASSWORD" ]; then
        echo "Error: Password not found."
        return 1
      fi

      file_path="$1"
      if [ -z "$file_path" ]; then
        echo "Usage: transfer <file>"
        return 1
      fi

      response=$(curl -sD - --user "jsw:$PASSWORD" --progress-bar --upload-file "$file_path" "https://share.jsw.tf/$(basename "$file_path")")

      if [ $? -eq 0 ]; then
          DELETE=$(echo "$response" | grep x-url-delete | sed "s/.*\///")
          URL=$(echo "$response" | tail -n1)

          echo "Delete code: $DELETE"
          echo "URL: $URL"
      else
        echo "Upload failed."
        return 1
      fi
      echo
    '')
  ];
}
