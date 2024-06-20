#!/bin/bash

# Load utility functions
source "$(dirname "$0")/extract_image_details.sh"

# Accept parameters
ALIYUN_REGISTRY=$1
ALIYUN_NAME_SPACE=$2

# Initialize associative arrays
declare -A duplicate_images
declare -A namespace_map

# Read images.txt and check for duplicates
while IFS= read -r line || [ -n "$line" ]; do
  [[ -z "$line" || "$line" =~ ^\s*# ]] && continue
  read -r image image_name_tag namespace image_name _ < <(extract_image_details "$line")
  if [[ -n "${namespace_map[$image_name]}" && "${namespace_map[$image_name]}" != "$namespace" ]]; then
    duplicate_images[$image_name]="true"
  fi
  namespace_map[$image_name]=$namespace
done < images.txt

# Pull, tag, push, and clean images
while IFS= read -r line || [ -n "$line" ]; do
  [[ -z "$line" || "$line" =~ ^\s*# ]] && continue
  read -r image image_name_tag namespace image_name platform_prefix < <(extract_image_details "$line")

  echo "image: '${image}'"
  echo "image_name_tag: '${image_name_tag}'"
  echo "namespace: '${namespace}'"
  echo "image_name '${image_name}'"
  echo "platform_prefix: '${platform_prefix}'"

  docker pull $image

  namespace_prefix=""
  if [[ -n "${duplicate_images[$image_name]}" && -n "$namespace" ]]; then
    namespace_prefix="${namespace}_"
  fi

  echo "namespace_prefix: '${namespace_prefix}'"

  if [[ -n "$platform_prefix" ]]; then
    new_image="$ALIYUN_REGISTRY/$ALIYUN_NAME_SPACE/${platform_prefix}/${namespace_prefix}${image_name_tag}"
  else
    new_image="$ALIYUN_REGISTRY/$ALIYUN_NAME_SPACE/${namespace_prefix}${image_name_tag}"
  fi

  echo "new_image: '${new_image}'"

  docker tag $image $new_image
  
  docker push $new_image

  # Clean up disk space
  docker rmi $image
  docker rmi $new_image
done < images.txt
