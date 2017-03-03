#!/usr/bin/env bash

set -x
set -e

TAG="${TRAVIS_TAG}"
COMMIT="${TRAVIS_COMMIT}"
BRANCH="${TRAVIS_BRANCH}"
PR="${TRAVIS_PULL_REQUEST}"

envsubst < conf/Dockerrun.aws.json.tmpl > Dockerrun.aws.json

if [ -z "${TAG}" ]; then
    echo "No tags, tagging as: ${COMMIT}"
    TAG="${COMMIT}"
fi

export TAG

# set beanstalk environments for dev and stage
# Prod will be deployed on Digital Ocean as specified in .travis.yml file
if [[ "${PR}" == "false" ]]; then
    if [[ "${BRANCH}" == "dev" ]]; then
        export DEPLOY_ENV="hospitalrun-dev"
    elif [[ "${BRANCH}" == "conf/docker" ]]; then
        export DEPLOY_ENV="hospitalrun-dev"
    elif [[ "${BRANCH}" == "stage" ]]; then
        export DEPLOY_ENV="hospitalrun-stage"
    fi
fi


$(aws ecr get-login --region="${AWS_REGION}")
docker-compose build
docker tag "${PROJECT_NAME}:latest" "${DOCKER_IMAGE_REPO}/${PROJECT_NAME}:${TAG}"
docker push "${DOCKER_IMAGE_REPO}/${PROJECT_NAME}:${TAG}"


envsubst < conf/travis-deploy.sh.tmpl > travis-deploy.sh

cat Dockerrun.aws.json
ls

chmod +x travis-deploy.sh