#!/usr/bin/env bash
sudo docker rm $(sudo docker ps -a -q) || : && cd ~/polyclinic && sudo docker-compose -f docker-compose-polyclinic.yml up --build -d