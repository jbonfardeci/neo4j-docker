#!/usr/bin/env bash

source .env

echo $ENV

NEO4J_DIR=/opt/neo4j
NEO4J_IMAGE=neo4j:community-5.7.0
DATA_DIR=$NEO4J_DIR/data
PLUGINS_DIR=$NEO4J_DIR/plugins
APOC=$PLUGINS_DIR/apoc-5.7.0-core.jar
APOC_URL=https://github.com/neo4j/apoc/releases/download/5.7.0/apoc-5.7.0-core.jar
GDS=$PLUGINS_DIR/neo4j-graph-data-science-2.3.4.jar
GDS_URL=https://github.com/neo4j/graph-data-science/releases/download/2.3.4/neo4j-graph-data-science-2.3.4.jar

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