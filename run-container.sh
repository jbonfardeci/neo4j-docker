#!/usr/bin/env bash

source .env

APOC="$PLUGINS_DIR/apoc-$APOC_VERSION-core.jar"
APOC_URL="https://github.com/neo4j/apoc/releases/download/$APOC_VERSION/apoc-$APOC_VERSION-core.jar"
GDS="$PLUGINS_DIR/neo4j-graph-data-science-$GDS_VERSION.jar"
GDS_URL="https://github.com/neo4j/graph-data-science/releases/download/$GDS_VERSION/neo4j-graph-data-science-$GDS_VERSION.jar"

if [ -d $DATA_DIR ]; then
    echo "$DATA_DIR already exists."
else
    echo "$DATA_DIR does not exist. Creating..."
    mkdir -p $DATA_DIR
fi

if [ -d $PLUGINS_DIR ]; then
    echo "$PLUGINS_DIR already exists."
else
    echo "$PLUGINS_DIR does not exist. Creating..."
    mkdir -p $PLUGINS_DIR
fi

if [ -d $IMPORT_DIR ]; then
    echo "$IMPORT_DIR already exists."
else
    echo "$IMPORT_DIR does not exist. Creating..."
    mkdir -p $IMPORT_DIR
fi

if [ ! -f $APOC ]; then
    echo "Downloading $APOC..." 
    sudo wget -P $PLUGINS_DIR $APOC_URL
else
    echo "${APOC} already exists."
fi

if [ ! -f $GDS ]; then
    echo "Downloading $GDS..."
    sudo wget -P $PLUGINS_DIR $GDS_URL
else
    echo "${GDS} already exists."
fi

sudo chmod -R 777 $NEO4J_DIR

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
    --network host \
    -p $NEO4J_FRONTEND_PORT:7474 \
    -p $NEO4J_PORT:7687 \
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
sudo chmod -R 777 $IMPORT_DIR
sudo docker ps -a -f name=$CONTAINER_NAME