#!/usr/bin/env bash
set -Eeuo pipefail

if [ ! -e config ]; then # first run, create directories and set ownership.
    mkdir -pv {db,log}
    cp -rv /elrond-config-mainnet config
    
    #Enable "Database Lookup Extensions"
    sed -i '/\[DbLookupExtensions\]/!b;n;c\\tEnabled = true' config/config.toml
    
    (
        cd config
        keygenerator
    )
    
    chown -R ${uid}:${uid} .
fi

# set reduced priviledges
exec setpriv --reuid=${uid} --regid=${uid} --init-groups $@
