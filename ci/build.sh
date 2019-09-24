#!/bin/sh

CI_URL=https://github.com/arcnmx/ci/archive/allnix.tar.gz
exec nix run -L --show-trace -f $CI_URL \
	--arg config ./ci/config.nix test.all -c ci-build "$@"
