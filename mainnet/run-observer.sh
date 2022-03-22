#!/bin/bash
docker run --mount type=bind,source=${OBSERVER_DIR},destination=/data --publish ${P2P_PORT}:37373 --network=elrond-squad --ip=${IP} --name squad-${SHARD} elrondnetwork/elrond-node-obs:v1.2.38 \
--destination-shard-as-observer=${SHARD} --display-name="${DISPLAY_NAME}"

