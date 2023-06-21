{ pkgs }:

let
  buildPythonPackage = pkgs.python311Packages.buildPythonPackage;
  fetchPypi = pkgs.python311Packages.fetchPypi;

  sdk = buildPythonPackage
    rec {
      pname = "cloudscale-sdk";
      version = "0.7.0";

      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-iHsvxgUJctA//flSFqWyup2OBPX3Xc+hFUfv9vA2H1U=";
      };

      doCheck = false;

      propagatedBuildInputs = with pkgs.python311Packages; [
        requests
        xdg
      ];
    };

  cli = buildPythonPackage
    rec {
      pname = "cloudscale-cli";
      version = "1.4.0";

      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-YfdiyUZmBOXwPtOeT7JoZMt3X37oIf36a+TIPvGJV/U=";
      };

      doCheck = false;

      propagatedBuildInputs = [
        sdk
      ] ++ (with pkgs.python311Packages; [
        click
        jmespath
        natsort
        pygments
        tabulate
        yaspin
      ]);
    };
in
{ inherit sdk cli; }
