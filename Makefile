image = deploy/image_2018-09-04-VideoPi-standard.zip

.PHONY: erase build build-continue install checkargs help

erase: checkargs  ## Overwrite the whole `device` with zeros.
	sudo dd if=/dev/zero "of=$(device)" iflag=nocache oflag=direct bs=4M status=progress

build:  ## Build the image.
	sudo systemctl start docker
	./fix-loopback.sh
	./build-docker.sh

build-continue:  ## Continue building the image (if previous build failed).
	CONTINUE=1 $(MAKE) build

install: checkargs  ## Install built image.
	cd "$$(dirname "$(image)")" && \
	sha1sum -c "$$(basename "$(image)").sha1"
	unzip -p "$(image)" | sudo dd "of=$(device)" bs=4 status=progress conv=fsync
	sudo sync

checkargs:
ifeq (,$(device))
	@echo "You must set the variable `device`."
	@echo "Example: make backup device=/dev/sdX"
	@exit 1
endif

help: # https://gist.github.com/jhermsmeier/2d831eb8ad2fb0803091
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-14s\033[0m %s\n", $$1, $$2}'
