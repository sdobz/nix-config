{ stdenv, appimage-run, fetchurl, runtimeShell }:

let
  version = "3.3.5";

  plat = {
    i386-linux = "i386";
    x86_64-linux = "x86_64";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    x86_64-linux = "0bnd369qznc4rw33wn1k3wdvmwfp7z4j02d4wfxz9k7limdicbsr";
  }.${stdenv.hostPlatform.system};
in

stdenv.mkDerivation {
  pname = "standardnotes";
  inherit version;

  src = fetchurl {
    url = "https://github.com/standardnotes/desktop/releases/download/v${version}/standard-notes-${version}.AppImage";
    inherit sha256;
  };

  buildInputs = [ appimage-run ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp $src $out/share/standardNotes.AppImage
    echo "#!${runtimeShell}" > $out/bin/standardnotes
    echo "${appimage-run}/bin/appimage-run $out/share/standardNotes.AppImage" >> $out/bin/standardnotes
    chmod +x $out/bin/standardnotes $out/share/standardNotes.AppImage
  '';

  meta = with stdenv.lib; {
    description = "A simple and private notes app";
    longDescription = ''
      Standard Notes is a private notes app that features unmatched simplicity,
      end-to-end encryption, powerful extensions, and open-source applications.
    '';
    homepage = https://standardnotes.org;
    license = licenses.agpl3;
    maintainers = with maintainers; [ mgregoire ];
    platforms = [ "i386-linux" "x86_64-linux" ];
  };
}
