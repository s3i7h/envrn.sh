#!/usr/bin/env bash
# envrn.sh - The ultimate bash task runner

# define each task as bash functions

hello() {
    for name in "$@";do
        echo "Hello, $name!"
    done
}

shell() {
    PATH="$PATH:$__DIR__" exec $SHELL
}

# add descriptions to each task

help() {
    cat << EOF
Usage: envrn.sh TASK|COMMAND [OPTIONS]

TASK:
    hello: shows a greeting message for each user
    shell: enters a new shell with .env read into, and __DIR__ added to \$PATH
    help: show this message
COMMAND:
    any command that will be run with .env read into
EOF
}

# --------------- envrn.sh -----------------
# (C) 2021 Yuichiro Smith <contact@yu-smith.com>
# This script is distributed under the Apache 2.0 License
# See the full license at https://github.com/yu-ichiro/envrn.sh/blob/main/LICENSE

__PWD__=$PWD
__DIR__="$(
  src="${BASH_SOURCE[0]}"
  while [ -h "$src" ]; do
    dir="$(cd -P "$(dirname "$src")" && pwd)"
    src="$(readlink "$src")"
    [[ $src != /* ]] && src="$dir/$src"
  done
  printf %s "$(cd -P "$(dirname "$src")" && pwd)"
)"

cd -P $__DIR__

_load_env() {
    # load envs declared as ENV_VAR=VALUE in files, process substitutions without overriding existing envs
    files="$(cat "$@" <(echo) <(declare -x | sed -E 's/^declare -x //g'))"
    set -a; eval "$files"; set +a;
}

if [ -e '.env' ];then
    _load_env .env
fi

task=${1:-help}
shift
$task "$@"
