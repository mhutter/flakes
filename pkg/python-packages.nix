{ pkgs }:

let
  inherit (upstream) buildPythonApplication buildPythonPackage fetchPypi;

  upstream = pkgs.python311Packages;
  poetry = upstream.poetry-core;

  pythonThing = builder:
    { pname
    , version
    , sha256
    , format ? "setuptools"
    , propagatedBuildInputs ? [ ]
    }: pkgs.lib.makeOverridable builder rec {
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

  pythonPackage = pythonThing buildPythonPackage;
  pythonApplication = pythonThing buildPythonApplication;

in
rec {
  cloudscale-cli = pythonApplication {
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
