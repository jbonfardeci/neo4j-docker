#!/bin/bash
mv neo4j.service /etc/systemd/neo4j.service
chmod a+x /etc/systemd/neo4j.service
systemctl daemon-reload
systemctl enable /etc/systemd/neo4j.service