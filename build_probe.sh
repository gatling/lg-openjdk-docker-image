#!/bin/bash

set -eux

java_major="$1"

base_image="openjdk:${java_major}-jre-slim"

docker pull "$base_image"

java_version=$(docker run --rm "$base_image" java -version 2>&1 | awk -F '"' '/version/ {print $2}')

docker build \
  --build-arg=base_image="$base_image" \
  -t gatlingcorp/frontline-injector:"$java_version" \
  .

docker tag \
  gatlingcorp/frontline-injector:"$java_version" \
  gatlingcorp/frontline-injector:"$java_major"

docker push gatlingcorp/frontline-injector:"$java_version"
docker push gatlingcorp/frontline-injector:"$java_major"
