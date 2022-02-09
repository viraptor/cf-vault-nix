{
  description = "cf-vault";

  outputs = { self, nixpkgs }: let
      # List of systems supported by home-manager binary
      supportedSystems = nixpkgs.lib.platforms.unix;

      # Function to generate a set based on supported systems
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);

      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in rec {
    defaultPackage = forAllSystems (system: nixpkgsFor.${system}.buildGoModule rec {
      pname = "cf-vault";
      version = "0.0.11";

      src = nixpkgsFor.${system}.fetchFromGitHub {
        owner = "jacobbednarz";
        repo = "cf-vault";
        rev = "${version}";
        sha256 = "sha256-Imd9qeT4xg5ujVPLHSSqoteSPl9t97q3Oc4C/vzHphg=";
      };

      proxyVendor = true;

      vendorSha256 = null;
    });

    defaultApp = forAllSystems (system: defaultPackage.${system});
  };
}
