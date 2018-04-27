{ stdenv, fetchFromGitHub, cmake, coreutils, perl, bicpl, libminc, zlib, minc_tools,
  makeWrapper, GetoptTabular, MNI-Perllib }:

stdenv.mkDerivation rec {
  pname = "conglomerate";
  name  = "${pname}-2017-09-10";

  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "7343238bc6215942c7ecc885a224f24433a291b0";
    sha256 = "1mlqgmy3jc13bv7d01rjwldxq0p4ayqic85xcl222hhifi3w2prr";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ libminc zlib bicpl ];
  propagatedBuildInputs = [ coreutils minc_tools perl GetoptTabular MNI-Perllib ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/" "-DBICPL_DIR=${bicpl}/lib/" ];

  checkPhase = "ctest --output-on-failure";  # still some weird test failures though

  postFixup = ''
    for p in $out/bin/*; do
      wrapProgram $p --prefix PERL5LIB : $PERL5LIB --set PATH "${stdenv.lib.makeBinPath [ coreutils minc_tools ]}";
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/BIC-MNI/conglomerate;
    description = "More command-line utilities for working with MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.free;
  };
}
