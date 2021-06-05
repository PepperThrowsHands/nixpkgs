{ lib
, aio-geojson-client
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "aio-geojson-nsw-rfs-incidents";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-nsw-rfs-incidents";
    rev = "v${version}";
    sha256 = "0g7a5sbp1y4shhsik924zssa2n7ima6p2zk1l890y66lyc168vws";
  };

  propagatedBuildInputs = [
    aio-geojson-client
    aiohttp
    pytz
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_geojson_nsw_rfs_incidents" ];

  meta = with lib; {
    description = "Python module for accessing the NSW Rural Fire Service incidents feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-nsw-rfs-incidents";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
