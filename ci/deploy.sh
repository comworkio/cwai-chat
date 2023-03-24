#!/usr/bin/env bash

source ./ci/compute-env.sh

ENV_FILE=".env.${ENV}"

echo "VERSION=${VERSION}" > "${ENV_FILE}"
echo "API_URL=${API_URL}" >> "${ENV_FILE}"

docker login "${CI_REGISTRY}" --username "${CI_REGISTRY_USER}" --password "${CI_REGISTRY_PASSWORD}"
docker-compose -f "docker-compose-${ENV}.yml" up -d --force-recreate
