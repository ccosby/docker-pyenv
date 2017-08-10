#!/bin/bash

shopt -s nullglob

repo=pyenv

if test -z "$DOCKER_ID_USER"
then
    echo "ERROR: Please set env DOCKER_ID_USER, then docker login"
    exit 1
fi

for f in bases/*/Dockerfile
do
    repotag=$(basename $(dirname $f))
    docker build -f $f -t $repo:$repotag .

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
            tags="--tag $repo:$tag-$repotag --tag $DOCKER_ID_USER/$repo:$tag-$repotag $tags"
        done

        dockerfile=$(mktemp --tmpdir=$PWD)
        cat >$dockerfile <<_EOF_
FROM $repo:$repotag
RUN pyenv install $PYTHON_VERSION
RUN pyenv global $PYTHON_VERSION
RUN pyenv rehash

USER root
RUN yum clean all
RUN yum remove -y gcc gcc-c++ make git patch *-devel kernel-headers glibc-headers
RUN rm -rf /var/cache/yum/* /var/lib/yum/repos/*

USER pyuser
_EOF_
        docker build -f $dockerfile $tags .
        rm -f $dockerfile
    done
done

docker push $DOCKER_ID_USER/$repo
