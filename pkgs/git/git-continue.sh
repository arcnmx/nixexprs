#!/usr/bin/env bash
set -eu

REPO=$(git rev-parse --git-dir)
FLAG=--continue
if [[ -e "$REPO/BISECT_LOG" ]]; then
	SUBCOMMAND=bisect
	if [[ ${1-} = bad ]]; then
		shift
		FLAG=bad
	else
		FLAG=good
	fi
elif [[ -e "$REPO/MERGE_HEAD" ]]; then
	SUBCOMMAND=merge
elif [[ -e "$REPO/REVERT_HEAD" ]]; then
	SUBCOMMAND=revert
elif [[ -e "$REPO/CHERRY_PICK_HEAD" ]]; then
	SUBCOMMAND=cherry-pick
elif [[ -e "$REPO/rebase" || -e "$REPO/rebase-apply" || -e "$REPO/rebase-merge" ]]; then
	SUBCOMMAND=rebase
else
	echo "no operation appears to be in progress" >&2
	exit 1
fi

exec git $SUBCOMMAND $FLAG "$@"
