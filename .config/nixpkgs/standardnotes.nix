{ stdenv, appimage-run, fetchurl, runtimeShell, pkgs }:

let
  version = "3.6.8";

  plat = {
    i386-linux = "i386";
    x86_64-linux = "x86_64";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    x86_64-linux = "1fk5iks3gx5q2186vxhgzdxn7vgywz195582isbfs7f0dlx7xiqm";
  }.${stdenv.hostPlatform.system};
in

stdenv.mkDerivation {
  pname = "standardnotes";
  inherit version;

  src = fetchurl {
    url = "https://github.com/standardnotes/desktop/releases/download/v${version}/standard-notes-${version}-linux-${plat}.AppImage";
    inherit sha256;
  };

  buildInputs = [ appimage-run ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp $src $out/share/standardNotes.AppImage
    echo "#!${runtimeShell}" > $out/bin/standardnotes
    echo "export LD_LIBRARY_PATH='${pkgs.libsecret}/lib'" > $out/bin/standardnotes
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
