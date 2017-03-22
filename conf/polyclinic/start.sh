#!/usr/bin/env bash
sudo docker rm $(sudo docker ps -a -q) || : && cd ~/polyclinic && sudo docker-compose -f ~/polyclinic/conf/polyclinic/docker-compose.yml up --build -d