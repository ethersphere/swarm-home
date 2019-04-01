#!/bin/bash -xe

RELEASE_DIR=`mktemp -d`

# Download and extract release
wget -v https://github.com/ethersphere/swarm-home/releases/download/$TRAVIS_TAG/$RELEASE_FILE
tar -zxvf $RELEASE_FILE -C $RELEASE_DIR

# Upload to swarm
swarm --bzzapi $SWARM_BZZ_API \
      --defaultpath $RELEASE_DIR/index.html \
      --recursive up $RELEASE_DIR
