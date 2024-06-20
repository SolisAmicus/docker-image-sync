#!/bin/bash

extract_image_details() {
  local line=$1
  local image=$(echo "$line" | awk '{print $NF}')
  image="${image%%@*}"
  local image_name_tag=$(echo "$image" | awk -F'/' '{print $NF}')
  local namespace=$(echo "$image" | awk -F'/' '{if (NF==3) print $2; else if (NF==2) print $1; else print ""}')
  namespace="${namespace}_"
  local image_name=$(echo "$image_name_tag" | awk -F':' '{print $1}')
  local platform=$(echo "$line" | awk -F'--platform[ =]' '{if (NF>1) print $2}' | awk '{print $1}')
  local platform_prefix="${platform//\//_}_"
  [ -z "$platform" ] && platform_prefix=""
  echo "$image $image_name_tag $namespace $image_name $platform_prefix"
}
