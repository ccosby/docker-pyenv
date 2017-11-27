#!/bin/bash

shopt -s nullglob

export REPO REPOTAG PYTHON_VERSION
REPO=pyenv

export PATH="/usr/local/opt/gettext/bin:$PATH"
if ! type envsubst &>/dev/null
then
    echo "ERROR: envsubst is not found in your PATH. It's in gettext. Use https://brew.sh/ on macOS"
fi

if test -z "$DOCKER_ID_USER"
then
    echo "ERROR: Please set env DOCKER_ID_USER, then docker login"
    exit 1
fi

for f in bases/*/Dockerfile
do
    REPOTAG=$(basename $(dirname $f))
    docker build --no-cache --pull --file $f --tag $REPO:$REPOTAG .

    for tagset in \
        "3.6.3 3.6 3" \
        "2.7.14 2.7 2" \
        "3.5.4 3.5" \
        "3.4.7 3.4" \
        "2.6.9 2.6"
    do
        PYTHON_VERSION=
        tags=
        for tag in $tagset
        do
            : ${PYTHON_VERSION:=$tag}
            tags="--tag $REPO:$tag-$REPOTAG --tag $DOCKER_ID_USER/$REPO:$tag-$REPOTAG $tags"
        done

        dockerfile=$(mktemp $PWD/Dockerfile.XXXXXX)
        envsubst >$dockerfile <$(dirname $f)/pyenv.Dockerfile
        docker build --file $dockerfile $tags .
        rm -f $dockerfile
    done
done

docker push $DOCKER_ID_USER/$REPO
