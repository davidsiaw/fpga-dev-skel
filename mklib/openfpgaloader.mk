# make utils for openFPGAloader

OFL_DOCKER_IMAGE=davidsiaw/yosys-docker
OFL_DOCKER_PREFIX=docker run --rm -v $$(pwd):/src --workdir /src
OFL_CMD_PREFIX=$(OFL_DOCKER_PREFIX) $(OFL_DOCKER_IMAGE)

OFL_PRIV_PREFIX=#$(OFL_DOCKER_PREFIX) --privileged -v /dev:/dev $(OFL_DOCKER_IMAGE)

OPENFPGALOADER=$(OFL_PRIV_PREFIX) openFPGALoader
