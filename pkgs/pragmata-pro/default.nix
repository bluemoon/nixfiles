{ stdenv, nerd-font-patcher, }:
stdenv.mkDerivation {
  pname = "pragmata-pro";
  version = "1.0.0";

  src = builtins.fetchGit {
    url = "git@github.com:bluemoon/font-pragmata-pro.git";
    rev = "8471c1332e9e39d70c656b3ef9be0a47ab353a2c";
  };

  nativeBuildInputs = [ nerd-font-patcher ];

  installPhase = ''
    runHook preInstall

    nerd-font-patcher --complete --use-single-width-glyphs --adjust-line-height --quiet --no-progressbars PragmataProR_0829.ttf

    mkdir -p $out/share/fonts/truetype
    install *.ttf $out/share/fonts/truetype
  '';
}
