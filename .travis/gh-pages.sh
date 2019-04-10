#!/bin/sh

SITE=/tmp/public
REPO=adamschmideg/swarm-home

setup_git() {
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "Travis CI"
}
generate_site() {
    mkdir -p $SITE/doc
    cd src && hugo -d $SITE && cd -
    # rename hugo-generated index.html, so it won't get overwritten by the main one
    mv $SITE/index.html $SITE/doc/index.html
    cp -r * $SITE
    rm -rf $SITE/src
}

commit_files() {
    git checkout gh-pages
    cp -r $SITE/* .
    git add *
    git commit -m"Travis build: $TRAVIS_BUILD_NUMBER"
}

upload() {
    git remote add origin-pages https://${GH_TOKEN}@github.com/$REPO.git > /dev/null 2>&1
    git push --quiet --set-upstream origin-pages gh-pages
}

setup_git
generate_site
commit_files
upload