{ lib, stdenv, fetchurl, fetchpatch, m4, ncurses, ocaml, writeText }:

stdenv.mkDerivation rec {
  pname = "ocaml-findlib";
  version = "1.9.1";

  src = fetchurl {
    url = "http://download.camlcity.org/download/findlib-${version}.tar.gz";
    sha256 = "sha256-K0K4vVRIjWTEvzy3BUtLN70wwdwSvUMeoeTXrYqYD+I=";
  };

  nativeBuildInputs = [m4 ocaml];
  buildInputs = [ ncurses ];

  patches = [ ./ldconf.patch ./install_topfind.patch ];

  dontAddPrefix=true;

  configureFlags = [
      "-bindir" "${placeholder "out"}/bin"
      "-mandir" "${placeholder "out"}/share/man"
      "-sitelib" "${placeholder "out"}/lib/ocaml/${ocaml.version}/site-lib"
      "-config" "${placeholder "out"}/etc/findlib.conf"
  ];

  buildFlags = [ "all" "opt" ];

  setupHook = writeText "setupHook.sh" ''
    addOCamlPath () {
        if test -d "''$1/lib/ocaml/${ocaml.version}/site-lib"; then
            export OCAMLPATH="''${OCAMLPATH-}''${OCAMLPATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/"
        fi
        if test -d "''$1/lib/ocaml/${ocaml.version}/site-lib/stublibs"; then
            export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH-}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/stublibs"
        fi
        export OCAMLFIND_DESTDIR="''$out/lib/ocaml/${ocaml.version}/site-lib/"
        if test -n "''${createFindlibDestdir-}"; then
          mkdir -p $OCAMLFIND_DESTDIR
        fi
    }

    addEnvHooks "$targetOffset" addOCamlPath
  '';

  meta = {
    homepage = "http://projects.camlcity.org/projects/findlib.html";
    description = "O'Caml library manager";
    license = lib.licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      lib.maintainers.maggesi
      lib.maintainers.vbmithr
    ];
  };
}


