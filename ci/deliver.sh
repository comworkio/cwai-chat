#!/usr/bin/env bash

source ./ci/compute-env.sh

sha="$(git rev-parse --short HEAD)"
details="$(git log --pretty=format:"%an, %ar : %s" -1)"

echo '{"version":"'"${VERSION}"'", "env":"'"${ENV}"'", "sha":"'"${sha}"'", "details":"'"${details}"'"}' > manifest.json
echo "POSTGRES_PORT=${CI_POSTGRES_PORT}" >> .env

docker login --username "${DOCKER_USERNAME}" --password "${DOCKER_ACCESS_TOKEN}"
docker-compose -f docker-compose-build.yml build  "${IMAGE_NAME}"
docker tag "${IMAGE_NAME}:latest" "${DOCKER_REGISTRY}/${IMAGE_NAME}:${VERSION}"
docker push "${DOCKER_REGISTRY}/${IMAGE_NAME}:${VERSION}"
