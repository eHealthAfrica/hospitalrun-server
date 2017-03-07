#!/usr/bin/env bash
service atd start
at -f /usr/src/app/conf/initcouch.sh now + 1 min
npm start