#!/usr/bin/env bash
sudo docker rm $(sudo docker ps -a -q) || : && cd ~/polyclinic && mv conf/polyclinic/docker-compose.yml . && sudo docker-compose up --build -d