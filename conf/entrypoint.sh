#!/usr/bin/env bash
RUN service atd start
RUN at -f /usr/src/app/conf/initcouch.sh now + 1 min
RUN echo "/usr/src/app/utils/elasticsearch.sh hradmin test" | at now + 1 min
npm start