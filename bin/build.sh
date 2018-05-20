#!/bin/bash
set -e

BUILD_ENV="${1:-prod}"
export MIX_ENV=${BUILD_ENV}
export REPLACE_OS_VARS=true

PROJECT_ROOT=$(pwd)
cd assets
if [ "$BUILD_ENV" = "prod" ]; then
  ./node_modules/brunch/bin/brunch build --production
else
  ./node_modules/brunch/bin/brunch build
fi
cd "$PROJECT_ROOT"

mix phoenix.digest
mix release --env "${BUILD_ENV}" --verbose
