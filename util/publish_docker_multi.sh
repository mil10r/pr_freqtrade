#!/bin/bash

source .env
echo $GHCR_TOKEN | docker login ghcr.io -u mil10r --password-stdin

IMAGE_NAME=pr_freqtrade
GHCR_IMAGE_NAME=ghcr.io/mil10r/${IMAGE_NAME}
TAG_PLOT=plot
TAG_FREQAI=freqai
TAG_FREQAI_RL=rl

docker tag freqtrade:$TAG ${GHCR_IMAGE_NAME}:$TAG

docker build --build-arg sourceimage=freqtrade --build-arg sourcetag=${TAG} -t ${IMAGE_NAME}:${TAG_PLOT} -f docker/Dockerfile.plot .
docker build --build-arg sourceimage=freqtrade --build-arg sourcetag=${TAG} -t ${IMAGE_NAME}:${TAG_FREQAI} -f docker/Dockerfile.freqai .
docker build --build-arg sourceimage=freqtrade --build-arg sourcetag=${TAG_FREQAI} -t ${IMAGE_NAME}:${TAG_FREQAI_RL} -f docker/Dockerfile.freqai_rl .

docker tag ${IMAGE_NAME}:$TAG_PLOT ${GHCR_IMAGE_NAME}:${TAG_PLOT}
docker tag ${IMAGE_NAME}:$TAG_FREQAI ${GHCR_IMAGE_NAME}:${TAG_FREQAI}
docker tag ${IMAGE_NAME}:$TAG_FREQAI_RL ${GHCR_IMAGE_NAME}:${TAG_FREQAI_RL}

docker images

docker push ${GHCR_IMAGE_NAME}:$TAG_PLOT
docker push ${GHCR_IMAGE_NAME}:$TAG_FREQAI
docker push ${GHCR_IMAGE_NAME}:$TAG_FREQAI_RL

docker images