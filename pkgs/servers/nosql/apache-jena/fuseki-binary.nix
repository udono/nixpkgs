{stdenv, fetchurl, java, makeWrapper}:
let
  s = # Generated upstream information
  rec {
    baseName="apache-jena-fuseki";
    version = "3.8.0";
    name="${baseName}-${version}";
    url="http://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-${version}.tar.gz";
    sha256 = "0jca96996zl3f1qc15sfv45n09rnnv24qxv87y16dnwnyc1ism0a";
  };
  buildInputs = [
    makeWrapper
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  installPhase = ''
    cp -r . "$out"
    ln -s "$out"/{fuseki-server,fuseki} "$out/bin"
    for i in "$out"/bin/*; do
      wrapProgram "$i" \
        --prefix "PATH" : "${java}/bin/" \
        --set-default "FUSEKI_HOME" "$out" \
        ;
    done
  '';
  meta = {
    inherit (s) version;
    description = ''SPARQL server'';
    license = stdenv.lib.licenses.asl20;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://jena.apache.org;
    downloadPage = "http://archive.apache.org/dist/jena/binaries/";
    downloadURLRegexp = "apache-jena-fuseki-.*[.]tar[.]gz\$";
  };
}
