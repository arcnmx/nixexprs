{ self, super, lib, ... }: with lib; let
  addPassthru = drv: {
    address = readFile "${drv}";
  };
  packages = {
    yggdrasil-address = { stdenvNoCC, yggdrasil }: pubkey: let
      yggEnc = {
        EncryptionPublicKey = pubkey;
      };
      yggSign = {
        SigningPublicKey = pubkey;
      };
      yggdrasilConf = if lib.versionAtLeast yggdrasil.version "0.4"
        then yggSign
        else yggEnc;
      drv = stdenvNoCC.mkDerivation {
        name = "yggdrasil-address-${pubkey}";

        nativeBuildInputs = [ yggdrasil ];

        yggdrasilConf = builtins.toJSON yggdrasilConf;

        passAsFile = [ "yggdrasilConf" ];

        buildCommand = ''
          yggdrasil -useconffile $yggdrasilConfPath -address | tr -d '\n' > $out
        '';
      };
    in drvPassthru addPassthru drv;
  };
in mapAttrs (_: p: self.callPackage p { }) packages
