{
  description = "cf-vault";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in rec {
          defaultPackage = pkgs.buildGoModule rec {
            pname = "cf-vault";
            version = "0.0.11";

            src = pkgs.fetchFromGitHub {
              owner = "jacobbednarz";
              repo = "cf-vault";
              rev = "${version}";
              sha256 = "sha256-Imd9qeT4xg5ujVPLHSSqoteSPl9t97q3Oc4C/vzHphg=";
            };

            proxyVendor = true;

            vendorSha256 = "sha256-SEC/qhvBmUpdXvAHWKylyiBl/MxThFAqy+0DcTDb9N4=";
          };

          apps = {
            cf-vault = {
              type = "app";
              program = "${defaultPackage.${system}}/bin/cf-vault";
            };
          };

          defaultApp = apps.${system}.cf-vault;
        }
      );
}
