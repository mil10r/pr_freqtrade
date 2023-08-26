#!/bin/bash

source .env
echo $GHCR_TOKEN | docker login ghcr.io -u mil10r --password-stdin

IMAGE_NAME=ghcr.io/mil10r/pr_freqtrade
TAG=pr_freqtrade
TAG_PLOT=${TAG}_plot
TAG_FREQAI=${TAG}_freqai
TAG_FREQAI_RL=${TAG_FREQAI}rl

docker tag freqtrade:$TAG ${IMAGE_NAME}:$TAG

docker build --build-arg sourceimage=freqtrade --build-arg sourcetag=${TAG} -t freqtrade:${TAG_PLOT} -f docker/Dockerfile.plot .
docker build --build-arg sourceimage=freqtrade --build-arg sourcetag=${TAG} -t freqtrade:${TAG_FREQAI} -f docker/Dockerfile.freqai .
docker build --build-arg sourceimage=freqtrade --build-arg sourcetag=${TAG_FREQAI} -t freqtrade:${TAG_FREQAI_RL} -f docker/Dockerfile.freqai_rl .

docker tag freqtrade:$TAG_PLOT ${IMAGE_NAME}:$TAG_PLOT
docker tag freqtrade:$TAG_FREQAI ${IMAGE_NAME}:$TAG_FREQAI
docker tag freqtrade:$TAG_FREQAI_RL ${IMAGE_NAME}:$TAG_FREQAI_RL

docker images

docker push ${IMAGE_NAME}:$TAG
docker push ${IMAGE_NAME}:$TAG_PLOT
docker push ${IMAGE_NAME}:$TAG_FREQAI
docker push ${IMAGE_NAME}:$TAG_FREQAI_RL

docker images