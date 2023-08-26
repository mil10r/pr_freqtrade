#!/bin/sh

# The below assumes a correctly setup docker buildx environment

IMAGE_NAME=freqtradeorg/freqtrade
CACHE_IMAGE=freqtradeorg/freqtrade_cache
BRANCH_NAME=pr_freqtrade
# Replace / with _ to create a valid tag
TAG=$(echo "${BRANCH_NAME}" | sed -e "s/\//_/g")
TAG_PLOT=${TAG}_plot
TAG_FREQAI=${TAG}_freqai
TAG_FREQAI_RL=${TAG_FREQAI}rl

# Tag image for upload and next build step
docker tag freqtrade:$TAG ${CACHE_IMAGE}:$TAG

docker build --build-arg sourceimage=freqtrade --build-arg sourcetag=${TAG} -t freqtrade:${TAG_PLOT} -f docker/Dockerfile.plot .
docker build --build-arg sourceimage=freqtrade --build-arg sourcetag=${TAG} -t freqtrade:${TAG_FREQAI} -f docker/Dockerfile.freqai .
docker build --build-arg sourceimage=freqtrade --build-arg sourcetag=${TAG_FREQAI} -t freqtrade:${TAG_FREQAI_RL} -f docker/Dockerfile.freqai_rl .

docker tag freqtrade:$TAG_PLOT ${CACHE_IMAGE}:$TAG_PLOT
docker tag freqtrade:$TAG_FREQAI ${CACHE_IMAGE}:$TAG_FREQAI
docker tag freqtrade:$TAG_FREQAI_RL ${CACHE_IMAGE}:$TAG_FREQAI_RL

docker images

docker push ${CACHE_IMAGE}:$TAG
docker push ${CACHE_IMAGE}:$TAG_PLOT
docker push ${CACHE_IMAGE}:$TAG_FREQAI
docker push ${CACHE_IMAGE}:$TAG_FREQAI_RL

docker images

if [ $? -ne 0 ]; then
    echo "failed building image"
    return 1
fi
