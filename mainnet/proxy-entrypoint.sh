#!/usr/bin/env bash
set -Eeuo pipefail

# set reduced priviledges
exec setpriv --reuid=${uid} --regid=${uid} --init-groups $@
