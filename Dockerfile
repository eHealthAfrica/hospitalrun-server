FROM node:4.4.3-slim
LABEL maintainer Mofesola Babalola <mofesola.babalola@ehealthnigeria.org>

#Get required applications
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y  curl wget

#Create App Directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

#Install Dependencies
COPY package.json /usr/src/app
RUN npm install --loglevel silent || :

COPY . /usr/src/app

#Setup the DB with initial user
RUN chmod +x conf/initcouch.sh
COPY config-example.js config.js

EXPOSE 3000

CMD ["npm", "start"]
