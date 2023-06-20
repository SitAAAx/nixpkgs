{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "mmh3";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BWuD0E5ZVUfQQHzI5apdi6iAKor6QXtkwcMCNbU4njA=";
  };

  pythonImportsCheck = [
    "mmh3"
  ];

  meta = with lib; {
    description = "Python wrapper for MurmurHash3, a set of fast and robust hash functions";
    homepage = "https://github.com/hajimes/mmh3";
    changelog = "https://github.com/hajimes/mmh3/blob/v${version}/CHANGELOG.md";
    license = licenses.cc0;
    maintainers = with maintainers; [ ];
  };
}
