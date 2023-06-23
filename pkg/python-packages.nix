{ pkgs }:

let
  inherit (upstream) buildPythonPackage fetchPypi;

  upstream = pkgs.python311Packages;
  poetry = upstream.poetry-core;

  pythonPackage =
    { pname
    , version
    , sha256
    , format ? "setuptools"
    , propagatedBuildInputs ? [ ]
    }: pkgs.lib.makeOverridable buildPythonPackage rec {
      inherit
        format
        pname
        propagatedBuildInputs
        version
        ;

      src = fetchPypi {
        inherit pname version sha256;
      };

      strictDeps = false;

      doCheck = false;
    };

in
rec {
  cloudscale-cli = pythonPackage {
    pname = "cloudscale-cli";
    version = "1.4.0";
    sha256 = "sha256-YfdiyUZmBOXwPtOeT7JoZMt3X37oIf36a+TIPvGJV/U=";
    propagatedBuildInputs = with upstream; [
      click
      cloudscale-sdk
      jmespath
      natsort
      pygments
      tabulate
      yaspin
    ];
  };

  cloudscale-sdk = pythonPackage {
    pname = "cloudscale-sdk";
    version = "0.7.0";
    sha256 = "sha256-iHsvxgUJctA//flSFqWyup2OBPX3Xc+hFUfv9vA2H1U=";
    propagatedBuildInputs = with upstream; [
      requests
      xdg
    ];
  };
}
