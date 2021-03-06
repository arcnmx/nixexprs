{
  notmuch-vim = { fetchFromGitHub, fetchurl, vimUtils, notmuch, ruby, buildRubyGem, buildEnv }: vimUtils.buildVimPlugin {
    name = "notmuch-vim";
    src = fetchFromGitHub {
      owner = "mashedcode";
      repo = "notmuch-vim";
      rev = "624c1d8619290193e33898036e830c8331855770";
      sha256 = "09gy6anknphj6q3amvxynx4djbvw5blb0v851sfwjrfl9m3qi67d";
    };
    patches = [
      (let
        rev = "929c8a083292ecdba3bea63dc8ce27ef7c8158e9";
      in fetchurl {
        name = "notmuch-vim.patch";
        url = "https://github.com/mashedcode/notmuch-vim/compare/master...arcnmx:${rev}.patch";
        sha256 = "0vx24g97ij76b6a4a5l9zchpvscgy5cljydq3xnc16ramhpwk9v5";
      })
    ];
    buildPhase = let
      mail-gpg = buildRubyGem {
        inherit ruby;
        pname = "mail-gpg";
        gemName = "mail-gpg";
        source.sha256 = "13gls1y55whsjx5wlykhq8k3fi2qmkars64xdxx91vwi8pacc5p1";
        type = "gem";
        version = "0.4.2";
      };
      gemEnv = buildEnv {
        name = "notmuch-vim-gems";
        paths = with ruby.gems; [ notmuch mail gpgme rack mail-gpg ];
        pathsToLink = [ "/lib" "/nix-support" ];
        # https://github.com/NixOS/nixpkgs/pull/76765
        postBuild = ''
          for gem in $out/lib/ruby/gems/*/gems/*; do
            cp -a $gem/ $gem.new
            rm $gem
            mv $gem.new $gem
          done
        '';
      };
    in ''
      echo 'let $GEM_PATH=$GEM_PATH . ":${gemEnv}/${ruby.gemPath}"' >> plugin/notmuch.vim
      echo 'let $RUBYLIB=$RUBYLIB . ":${gemEnv}/${ruby.libPath}/${ruby.system}"' >> plugin/notmuch.vim
    '';
    meta.broken = notmuch.meta.broken or false;
  };
  vim-hug-neovim-rpc = { fetchFromGitHub, vimUtils }: vimUtils.buildVimPlugin rec {
    name = "vim-hug-neovim-rpc";
    src = fetchFromGitHub {
      owner = "roxma";
      repo = "vim-hug-neovim-rpc";
      rev = "6532acee7a06b2420160279fdd397b9d8e5f1e8a";
      sha256 = "0q6anf5f7s149ssmqfm9w4mkcgalwjflr2nh2kw0pqbwpbk925v8";
    };
  };
}
