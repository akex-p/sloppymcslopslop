#!/bin/sh
printf '\033c\033]0;%s\a' Sloppy Mc Slop Slopers
base_path="$(dirname "$(realpath "$0")")"
"$base_path/askbob.x86_64" "$@"
