#!/usr/bin/env bash

source ./ci/compute-env.sh

ENV_FILE=".env.${ENV}"

echo "VERSION=${VERSION}" > "${ENV_FILE}"

env|grep -E "^(MATOMO|API)_"|while read -r; do
  echo "${REPLY}" >> "${ENV_FILE}"
done

docker login --username "${DOCKER_USERNAME}" --password "${DOCKER_ACCESS_TOKEN}"
docker-compose -f "docker-compose-${ENV}.yml" up -d --force-recreate
