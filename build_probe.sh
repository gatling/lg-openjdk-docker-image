#!/usr/bin/env bash

set -eux

JAVA_MAJOR_VERSION=$1
BASE_DOCKER_IMAGE="openjdk:${JAVA_MAJOR_VERSION}-jre-slim"

docker pull "${BASE_DOCKER_IMAGE}"

EXACT_JAVA_VERSION=$(docker run --rm "$BASE_DOCKER_IMAGE" java -version 2>&1 | awk -F '"' '/version/ {print $2}')

docker build \
  --build-arg=JAVA_VERSION="$JAVA_MAJOR_VERSION" \
  -t gatlingcorp/frontline-injector:"$EXACT_JAVA_VERSION" \
  .

docker tag \
  gatlingcorp/frontline-injector:"$EXACT_JAVA_VERSION" \
  gatlingcorp/frontline-injector:"$JAVA_MAJOR_VERSION"

docker push gatlingcorp/frontline-injector:"$EXACT_JAVA_VERSION"
docker push gatlingcorp/frontline-injector:"$JAVA_MAJOR_VERSION"
