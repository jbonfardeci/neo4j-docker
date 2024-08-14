#!/usr/bin/env bash

IMAGE_NAME=neo4j:community-5.21.0
ECR_KEY=701186259805
REGION=us-east-1

sudo docker tag $IMAGE_NAME "$ECR_KEY.dkr.ecr.$REGION.amazonaws.com/$IMAGE_NAME"
# https://forums.docker.com/t/docker-push-to-ecr-failing-with-no-basic-auth-credentials/17358/33
PWD=$(aws ecr get-login-password | sed 's|https://||')
# 
sudo docker login --username AWS --password $PWD "$ECR_KEY.dkr.ecr.$REGION.amazonaws.com"
sudo docker push "$ECR_KEY.dkr.ecr.$REGION.amazonaws.com/$IMAGE_NAME"