#!/usr/bin/env bash

source .env
echo $ENV
echo "Building image..."
sudo docker build . -t $NEO4J_IMAGE