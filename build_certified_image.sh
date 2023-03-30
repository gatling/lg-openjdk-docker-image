#!/bin/bash

set -eux

java_version="$1"
base_image="gatlingcorp/openjdk-base:$java_version-jre-headless"
target_image="gatlingcorp/experimental-openjdk-x86:$java_version"

docker build \
  --platform linux/amd64 \
  --build-arg "BASE_IMAGE=$base_image" \
  --tag "$target_image" \
  .

docker push "$target_image"
