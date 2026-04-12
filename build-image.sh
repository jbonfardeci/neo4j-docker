#!/usr/bin/env bash

source .env
echo $ENV
echo "Building image..."
docker build . -t $NEO4J_IMAGE