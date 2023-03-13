#!/bin/bash

set -eux

java_major="$1"
java_latest="$2"

base_image="azul/zulu-openjdk:$java_major-jre-headless"

docker pull "$base_image"

java_version=$(docker run --rm "$base_image" java -version 2>&1 | awk -F '"' '/version/ {print $2}')

docker build \
  --build-arg=base_image=$base_image \
  -t gatlingcorp/classic-openjdk-x86:$java_version \
  .

if [ "$java_major" = "$java_latest" ]; then
  docker tag \
    gatlingcorp/classic-openjdk-x86:$java_version \
    gatlingcorp/classic-openjdk-x86:latest
  docker push gatlingcorp/classic-openjdk-x86:latest
else
  docker tag \
    gatlingcorp/classic-openjdk-x86:$java_version \
    gatlingcorp/classic-openjdk-x86:$java_major
  docker push gatlingcorp/classic-openjdk-x86:$java_version
  docker push gatlingcorp/classic-openjdk-x86:$java_major
fi
