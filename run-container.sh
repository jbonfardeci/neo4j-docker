#!/usr/bin/env bash

source .env

IMAGE_NAME="neo4j:community-5.7.0"

echo "Running container..."

# Docker-specific configuration settings
# Ref: https://neo4j.com/docs/operations-manual/current/docker/ref-settings/

# Ref: https://neo4j.com/docs/operations-manual/current/docker/introduction/

NEO4J_DIR=/opt/neo4j
DATA_DIR=$NEO4J_DIR/data
PLUGINS_DIR=$NEO4J_DIR/plugins

CONTAINER_NAME=neo4j
CONTAINER_ID=$(sudo docker ps -aq -f name=$CONTAINER_NAME)
if [ -n "$CONTAINER_ID" ]; then
    sudo docker stop $CONTAINER_ID
    echo "Neo4j container stopped."
    sudo docker rm -f $CONTAINER_ID
    echo "Neo4j container removed."
fi

sudo docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    -p 7474:7474 \
    -p 7687:7687 \
    -v $DATA_DIR:/data \
    -v $PLUGINS_DIR:/plugins \
    -e NEO4J_PLUGINS=/var/lib/neo4j/plugins \
    -e NEO4J_AUTH=$NEO4J_USERNAME/$NEO4J_PASSWORD \
    -e NEO4J_dbms_security_procedures_unrestricted="apoc.*,gds.*" \
    $IMAGE_NAME

echo "Container Neo4j started."
sleep 5
sudo docker ps -a -f name=$CONTAINER_NAME