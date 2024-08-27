#!/bin/bash

function aws_s3_sync() {
  local source=$1
  local destination=$2

  echo "~~~ :s3: ACL PRINT OUT"
  echo $BUILDKITE_PLUGIN_AWS_S3_SYNC_ACL

  params=()

  if [[ "${BUILDKITE_PLUGIN_AWS_S3_SYNC_DELETE:-false}" == "true" ]]; then
    params+=(--delete)
  fi

  if [[ "${BUILDKITE_PLUGIN_AWS_S3_SYNC_FOLLOW_SYMLINKS:-true}" == "false" ]]; then
    params+=(--no-follow-symlinks)
  fi

  if [[ -n "${BUILDKITE_PLUGIN_AWS_S3_SYNC_CACHE_CONTROL:-}" ]] && [[ $destination == s3://* ]]; then
    params+=("--cache-control=${BUILDKITE_PLUGIN_AWS_S3_SYNC_CACHE_CONTROL/\ /}")
  fi

  if [[ -n "${BUILDKITE_PLUGIN_AWS_S3_SYNC_ENDPOINT_URL:-}" ]]; then
    params+=("--endpoint-url=${BUILDKITE_PLUGIN_AWS_S3_SYNC_ENDPOINT_URL/\ /}")
  fi

  if [[ -n "${BUILDKITE_PLUGIN_AWS_S3_SYNC_EXCLUDE:-}" ]]; then
    params+=("--exclude=${BUILDKITE_PLUGIN_AWS_S3_SYNC_EXCLUDE/\ /}")
  fi

  if [[ -n "${BUILDKITE_PLUGIN_AWS_S3_SYNC_ACL:-}" ]]; then
    params+=("--acl=${BUILDKITE_PLUGIN_AWS_S3_SYNC_ACL/\ /}")
  fi

  params+=("$source")
  params+=("$destination")

  echo "~~~ :s3: Syncing $source to $destination"
  aws s3 sync "${params[@]}"
}
