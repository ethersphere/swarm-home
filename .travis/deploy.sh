#!/bin/bash -xe
TAG="${TAG:-$TRAVIS_TAG}"

SWARM_BZZ_API="https://swarm-public-staging.stg.swarm-gateways.net/"

GITHUB_ORG="ethersphere"
GITHUB_REPO="swarm-home"
GITHUB_USER="${GITHUB_USER:-bzzbot}"
GITHUB_SECRET="${GITHUB_SECRET:$RELEASE_OAUTH_TOKEN}"

RELEASE_DIR=$(mktemp -d)
RELEASE_FILE="swarm-home-$TAG.tar.gz"

# Download and extract release
wget -v "https://github.com/$GITHUB_ORG/$GITHUB_REPO/releases/download/$TAG/$RELEASE_FILE"
tar -zxvf "$RELEASE_FILE" -C "$RELEASE_DIR"

# Upload to swarm
echo "Uploading $TAG to swarm..."
SWARM_MANIFEST=$(swarm --bzzapi $SWARM_BZZ_API --defaultpath "$RELEASE_DIR/index.html" --recursive up "$RELEASE_DIR")

# Update GitHub release description
RID=$(curl -s -u "$GITHUB_USER:$GITHUB_SECRET" \
      "https://api.github.com/repos/$GITHUB_ORG/$GITHUB_REPO/releases/tags/$TAG" | jq '.id')

echo "Updating release notes for release $RID ..."
curl -u "$GITHUB_USER:$GITHUB_SECRET" -i -X PATCH \
  "https://api.github.com/repos/$GITHUB_ORG/$GITHUB_REPO/releases/$RID" \
  -H "Accept: application/json" \
  -d @- << EOF
{
  "tag_name": "$TAG",
  "name": "$TAG",
  "body": "[\`bzz://$SWARM_MANIFEST\`](https://swarm-gateways.net/bzz:/$SWARM_MANIFEST/)"
}
EOF
