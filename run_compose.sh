#!/usr/bin/env bash

docker-compose up -d --build
sleep 5
docker exec -it hospitalrun ./conf/initcouch.sh
sleep 20
docker exec -it hospitalrun ./utils/elasticsearch.sh hradmin test