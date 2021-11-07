#!/usr/bin/env bash
# envrn.sh - The ultimate bash task runner

# define any project related variables that should be declared in envrn.sh.
# (Note: the local .env file will be read to, but this will override it)

export PROJECT_NAME="test-project"
export VERSION="1.0.0"

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

if [ -e '.env' ];then
    set -a; eval "$(cat .env <(echo) <(declare -x))"; set +a;
fi

task=${1:-help}
shift
$task "$@"
