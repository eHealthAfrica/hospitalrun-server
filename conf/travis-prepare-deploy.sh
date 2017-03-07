#!/usr/bin/env bash

set -x
set -e

TAG="${TRAVIS_TAG}"
COMMIT="${TRAVIS_COMMIT}"
BRANCH="${TRAVIS_BRANCH}"
PR="${TRAVIS_PULL_REQUEST}"


if [ -z "${TAG}" ]; then
    echo "No tags, tagging as: ${COMMIT}"
    TAG="${COMMIT}"
fi

export TAG=$TAG

# set beanstalk environments for dev and stage
# Prod will be deployed on Digital Ocean as specified in .travis.yml file
if [[ "${PR}" == "false" ]]; then
    if [[ "${BRANCH}" == "dev" ]]; then
        export DEPLOY_ENV="hospitalrun-dev"
    elif [[ "${BRANCH}" == "stage" ]]; then
        export DEPLOY_ENV="hospitalrun-stage"
    fi
fi

if [[ "${BRANCH}" == "dev" || "${BRANCH}" == "stage" || "${BRANCH}" == "master" ]]; then
    $(aws ecr get-login --region="${AWS_REGION}")
    docker-compose build
    docker tag "${PROJECT_NAME}:latest" "${DOCKER_IMAGE_REPO}/${PROJECT_NAME}:${TAG}"
    docker push "${DOCKER_IMAGE_REPO}/${PROJECT_NAME}:${TAG}"

    # Push Logstash
    docker tag "${PROJECT_NAME}_logstash:latest" "${DOCKER_IMAGE_REPO}/${PROJECT_NAME}_logstash:${TAG}"
    docker push "${DOCKER_IMAGE_REPO}/${PROJECT_NAME}_logstash:${TAG}"

    # Substitute Environment Variables
    envsubst < conf/travis-deploy.sh.tmpl > travis-deploy.sh && envsubst < conf/Dockerrun.aws.json.tmpl > Dockerrun.aws.json

    chmod +x travis-deploy.sh
        elif [[ "${BRANCH}" == "eHA/Polyclinic" ]]; then
            envsubst < conf/polyclinic/polyclinic-deploy.sh.tmpl > conf/polyclinic/polyclinic-deploy.sh
            chmod +x conf/polyclinic/polyclinic-deploy.sh
    else echo "Branch is not a baseline branch. No build will be made or pushed to the repository"
fi