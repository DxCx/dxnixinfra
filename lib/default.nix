let
  entries = builtins.readDir ./.;
  isLibFile = name:
    entries.${name} == "regular" && name != "default.nix" && builtins.match ".*\\.nix" name != null;
  libFiles = builtins.filter isLibFile (builtins.attrNames entries);
  nameOf = file: builtins.replaceStrings [".nix"] [""] file;
in
  builtins.listToAttrs (map (file: {
      name = nameOf file;
      value = import (./. + "/${file}");
    })
    libFiles)
