#!/bin/bash
set -e

scripts="$(dirname "$0")"

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

tags=()
if [ -n "$TRAVIS_TAG" ]; then
    tags+=("$TRAVIS_TAG" latest)
elif [ -n "$TRAVIS_BRANCH" ]; then
    if [ "$TRAVIS_BRANCH" = "master" ]; then
        tags+=(latest)
    else
        tags+=("$TRAVIS_BRANCH")
    fi
fi

docker_image_name="qlcchain/oracle"

"$scripts"/custom-timeout.sh 30 docker build -f docker/Dockerfile -t "$docker_image_name" .
for tag in "${tags[@]}"; do
    # Sanitize docker tag
    # https://docs.docker.com/engine/reference/commandline/tag/
    tag="$(printf '%s' "$tag" | tr -c '[a-z][A-Z][0-9]_.-' -)"
    if [ "$tag" != "latest" ]; then
        docker tag "$docker_image_name" "${docker_image_name}:$tag"
    fi
    "$scripts"/custom-timeout.sh 30 docker push "${docker_image_name}:$tag"
done
