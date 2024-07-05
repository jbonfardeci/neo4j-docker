#!/usr/bin/env bash

source .env

echo $ENV

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
echo "Building image..."
sudo docker build . -t $NEO4J_IMAGE