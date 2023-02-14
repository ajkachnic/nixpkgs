{ lib, fetchFromGitHub, rustPlatform, crate2nix }:

rustPlatform.buildRustPackage rec {
  pname = "nix-start";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "ajkachnic";
    repo = pname;
    rev = "v${version}";
    sha256 = "eCA2aMGju9YUH+Ar25EtX1yckjNO+M3Y/khCj7Xa81c=";
  };

  meta = with lib; {
    description = "A simple utility for quickly starting nix-shell sessions";
    homepage = "https://github.com/ajkachnic/nix-start";
  };

  cargoSha256 = "h9KVoE4wbGaQ7kaqsw5pbPM7QKAnIrcz9JBIPr7j2zI=";
}
