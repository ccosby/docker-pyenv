#!/bin/bash

shopt -s nullglob

export REPO REPOTAG PYTHON_VERSION
REPO=pyenv

if test -z "$DOCKER_ID_USER"
then
    echo "ERROR: Please set env DOCKER_ID_USER, then docker login"
    exit 1
fi

for f in bases/*/Dockerfile
do
    REPOTAG=$(basename $(dirname $f))
    docker build -f $f -t $REPO:$REPOTAG .

    for tagset in \
        "3.6.2 3.6 3" \
        "2.7.13 2.7 2" \
        "3.5.3 3.5" \
        "3.4.6 3.4" \
        "2.6.9 2.6"
    do
        PYTHON_VERSION=
        tags=
        for tag in $tagset
        do
            : ${PYTHON_VERSION:=$tag}
            tags="--tag $REPO:$tag-$REPOTAG --tag $DOCKER_ID_USER/$REPO:$tag-$REPOTAG $tags"
        done

        dockerfile=$(mktemp --tmpdir=$PWD)
        envsubst >$dockerfile <$(dirname $f)/pyenv.Dockerfile
        docker build -f $dockerfile $tags .
        rm -f $dockerfile
    done
done

docker push $DOCKER_ID_USER/$REPO
