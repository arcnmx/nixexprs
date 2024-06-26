{
  notmuch-vim = { fetchFromGitHub, fetchpatch, vimUtils, notmuch, ruby, buildRubyGem, buildEnv, lib }:
  let
    mail-gpg = buildRubyGem {
        inherit ruby;
        pname = "mail-gpg";
        gemName = "mail-gpg";
        source.sha256 = "13gls1y55whsjx5wlykhq8k3fi2qmkars64xdxx91vwi8pacc5p1";
        type = "gem";
        version = "0.4.2";
      };
    mini_mime = buildRubyGem {
      inherit ruby;
      pname = "mini_mime";
      gemName = "mini_mime";
      source.sha256 = "0lbim375gw2dk6383qirz13hgdmxlan0vc5da2l072j3qw6fqjm5";
      type = "gem";
      version = "1.1.2";
    };
    mail = buildRubyGem {
      inherit ruby;
      pname = "mail";
      gemName = "mail";
      source.sha256 = "00wwz6ys0502dpk8xprwcqfwyf3hmnx6lgxaiq6vj43mkx43sapc";
      type = "gem";
      version = "2.7.1";
    };
    hasRuby = notmuch ? ruby || notmuch ? passthru.gemEnv;
  in vimUtils.buildVimPlugin rec {
    pname = "notmuch-vim";
    version = "2018-08-23";
    src = fetchFromGitHub {
      owner = "mashedcode";
      repo = "notmuch-vim";
      rev = "624c1d8619290193e33898036e830c8331855770";
      sha256 = "09gy6anknphj6q3amvxynx4djbvw5blb0v851sfwjrfl9m3qi67d";
    };
    patches = [
      (let
        rev = "7423e2a42622cb12342b14fa0c3123b005ce8096";
      in fetchpatch {
        name = "notmuch-vim.patch";
        url = "https://github.com/mashedcode/notmuch-vim/compare/${src.rev}...arcnmx:${rev}.patch";
        sha256 = "sha256-5M67QLEXeo64SEzyvDHqTZSButTeR+w68otR1FMTKS4=";
      })
    ];
    gemEnv = buildEnv {
      name = "notmuch-vim-gems";
      paths = with ruby.gems; [ mail net-smtp mini_mime gpgme rack mail-gpg ]
      ++ lib.optional hasRuby notmuch.ruby or notmuch.out;
      pathsToLink = [ "/lib" "/nix-support" ];
    };
    buildPhase = let
    in ''
      cat >> plugin/notmuch.vim << EOF
      let \$GEM_PATH=\$GEM_PATH . ":$gemEnv/${ruby.gemPath}"
      let \$RUBYLIB=\$RUBYLIB . ":$gemEnv/${ruby.libPath}/${ruby.system}"
      if has('nvim')
      EOF
      for gem in $gemEnv/${ruby.gemPath}/gems/*/lib; do
      echo "ruby \$LOAD_PATH.unshift('$gem')" >> plugin/notmuch.vim
      done
      echo 'endif' >> plugin/notmuch.vim
    '';
    meta.broken = notmuch.meta.broken or false || ! hasRuby;
  };
  vim-hug-neovim-rpc = { fetchFromGitHub, vimUtils }: vimUtils.buildVimPlugin rec {
    pname = "vim-hug-neovim-rpc";
    version = "2021-05-14";
    src = fetchFromGitHub {
      owner = "roxma";
      repo = "vim-hug-neovim-rpc";
      rev = "93ae38792bc197c3bdffa2716ae493c67a5e7957";
      sha256 = "0v7940h1sy8h6ba20qdadx82zbmi9mm4yij9gsxp3d9n94av8zsx";
    };
  };
  vim-actionscript = { fetchurl, vimUtils }: vimUtils.buildVimPlugin {
    pname = "actionscript.vim";
    version = "0.3";
    src = fetchurl {
      name = "actionscript.vim";
      url = "https://www.vim.org/scripts/download_script.php?src_id=10123";
      sha256 = "sha256-8BEggZhdsCw3f+ZiEtR9x5O5VzDGq/2qAF9O01n0t/4=";
    };
    sourceRoot = "actionscript.vim";

    unpackPhase = ''
      runHook preUnpack

      ls -lh $src
      install -Dm755 $src $sourceRoot/syntax/actionscript.vim

      runHook postUnpack
    '';

    postPatch = ''
      sed -i syntax/actionscript.vim \
        -e '/^syn match *actionScriptInParen *contained/d'
    '';
  };
}
