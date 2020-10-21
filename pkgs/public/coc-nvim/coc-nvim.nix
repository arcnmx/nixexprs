{ fetchFromGitHub, yarn2nix, yarn, vimUtils, nodePackages }: let
  pname = "coc-nvim";
  version = "0.0.79";
  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc.nvim";
    rev = "4f40c16a15"; # see get version() in build/index.js
    sha256 = "04ix0hj81djq97ivszwc8v9ifas4m0dkqlv3dn9qw0csa98hn7w1";
  };
  deps = yarn2nix.mkYarnModules rec {
    inherit pname version;
    name = "${pname}-modules-${version}";
    packageJSON = src + "/package.json";
    yarnLock = src + "/yarn.lock";
    yarnNix = ./yarn.nix;
  };
in vimUtils.buildVimPluginFrom2Nix {
  inherit version pname src;

  nativeBuildInputs = with nodePackages; [ webpack-cli yarn ];
  NODE_PATH = "${nodePackages.webpack}/lib/node_modules";

  configurePhase = ''
    mkdir -p node_modules
    ln -s ${deps}/node_modules/* node_modules/
    ln -s ${deps}/node_modules/.bin node_modules/

    # fragile :(
    substituteInPlace webpack.config.js \
      --replace "/Users/chemzqm/.config/yarn/global/node_modules/" "" \
      --replace "git rev-parse HEAD" "echo $version" \
      --replace "res.slice(0, 10)" "res"
  '';

  buildPhase = ''
    yarn build

    webpack-cli
    rm -r node_modules
  '';

  meta.broken = !(builtins.tryEval yarn2nix).success || yarn.stdenv.isDarwin;
}
