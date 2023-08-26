#!/bin/bash

check_command_success() {
    if [ $? -eq 0 ]; then
        echo "Command '$1' succeeded. Continuing with the script."
        # Continue with your script logic here
    else
        echo "Command '$1' failed. Exiting the script."
        exit 1  # You can exit with a non-zero status to indicate an error
    fi
}

source util/.env
echo $GHCR_TOKEN | docker login ghcr.io -u mil10r --password-stdin

check_command_success "login to ghcr.io"

IMAGE_NAME=pr_freqtrade
GHCR_IMAGE_NAME=ghcr.io/mil10r/${IMAGE_NAME}
TAG=latest
TAG_PLOT=plot
TAG_FREQAI=freqai
TAG_FREQAI_RL=rl

docker build -t ${IMAGE_NAME}:${TAG} -t ${GHCR_IMAGE_NAME}:${TAG} . &&
docker build --build-arg sourceimage=${IMAGE_NAME} --build-arg sourcetag=${TAG} -t ${IMAGE_NAME}:${TAG_PLOT} -f docker/Dockerfile.plot . &&
docker build --build-arg sourceimage=${IMAGE_NAME} --build-arg sourcetag=${TAG} -t ${IMAGE_NAME}:${TAG_FREQAI} -f docker/Dockerfile.freqai . &&
docker build --build-arg sourceimage=${IMAGE_NAME} --build-arg sourcetag=${TAG_FREQAI} -t ${IMAGE_NAME}:${TAG_FREQAI_RL} -f docker/Dockerfile.freqai_rl .

check_command_success "build all docker images"

docker tag ${IMAGE_NAME}:${TAG_PLOT} ${GHCR_IMAGE_NAME}:${TAG_PLOT} &&
docker tag ${IMAGE_NAME}:${TAG_FREQAI} ${GHCR_IMAGE_NAME}:${TAG_FREQAI} &&
docker tag ${IMAGE_NAME}:${TAG_FREQAI_RL} ${GHCR_IMAGE_NAME}:${TAG_FREQAI_RL}

check_command_success "tag all docker images"

docker images

docker push ${GHCR_IMAGE_NAME}:${TAG} &&
docker push ${GHCR_IMAGE_NAME}:$TAG_PLOT &&
docker push ${GHCR_IMAGE_NAME}:$TAG_FREQAI &&
docker push ${GHCR_IMAGE_NAME}:$TAG_FREQAI_RL

check_command_success "push all docker images to ghcr.io"

docker images