#!/bin/sh
# Run knives with the jj its jj-lib matches first on PATH.
libexec="$(dirname "$(readlink -f "$0")")/../libexec/knives"
PATH="$libexec:$PATH"
export PATH
exec "$libexec/knives" "$@"
