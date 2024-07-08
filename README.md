# Run a Neo4j Docker Container with Volume Mount

This solution builds a Neo4j Docker image with a volume mount, and the APOC and GDS plugins.

To run, first set your environment variables in the `.env` file in this repo. You can change the defaults below to the appropriate values for your environment. The variable names are:

```bash
ENV=local
NEO4J_DIR=/opt/neo4j
DATA_DIR=/opt/neo4j/data
NEO4J_IMAGE=neo4j:community-5.7.0
PLUGINS_DIR=/opt/neo4j/plugins
NEO4J_PORT=7687
NEO4J_FRONTEND_PORT=7474
NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=<YOUR_PASSWORD> # Replace with a strong password.
CONTAINER_NAME=neo4j
APOC_VERSION=5.21.0
GDS_VERSION=2.7.0
```

If you want to run multiple instances of Neo4j, you must set all of these variables to unique values. For example, increment the values for `NEO4J_PORT` to 7687, 7688, 7689, etc.


Then run the followinf shell scripts in this order:
1. `./build-image.sh`
2. `./run-container.sh`

To verify installation, open your browser to http://localhost:7474/browser. You should see the Neo4j user interface.