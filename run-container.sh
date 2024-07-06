#!/usr/bin/env bash

source .env

echo "Running container..."

# Docker-specific configuration settings
# Ref: https://neo4j.com/docs/operations-manual/current/docker/ref-settings/

# Ref: https://neo4j.com/docs/operations-manual/current/docker/introduction/

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
    -p $NEO4J_FRONTEND_PORT:$NEO4J_FRONTEND_PORT \
    -p $NEO4J_PORT:$NEO4J_PORT \
    -v $HOME/neo4j/data:/data \
    -v $HOME/neo4j/import:/var/lib/neo4j/import \
    -v $PLUGINS_DIR:/plugins \
    -e NEO4J_PLUGINS=/var/lib/neo4j/plugins \
    -e NEO4J_AUTH=$NEO4J_USERNAME/$NEO4J_PASSWORD \
    -e NEO4J_dbms_security_procedures_unrestricted="apoc.*,gds.*" \
    -e apoc.import.file.enabled=true \
    $NEO4J_IMAGE

echo "Container Neo4j started."
sleep 5
sudo docker ps -a -f name=$CONTAINER_NAME