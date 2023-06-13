# ============================================================================= #
# Version  v1.1.0                                                               #
# Date     2023.06.08                                                           #
# CoachCrew.tech                                                                #
# admin@CoachCrew.tech                                                          #
# ============================================================================= #

.PHONY: help build-image run-develop run-test

CONTAINER_DIR      ?= .devcontainer
WORK_DIR           ?= $(shell pwd)/..
USERNAME           ?= testuser
USER_UID           ?= 1000
USER_GID           ?= 1000

IMAGE_NAME         ?= cv_latex
CONTAINER_NAME     ?= $(IMAGE_NAME)-$(USERNAME)-$(shell date +"%Y-%m-%d.%H-%M")
DOCKER_FILE        ?= $(CONTAINER_DIR)/texlive.Dockerfile
DOCKER_ENTRYPOINT  ?= $(CONTAINER_DIR)/develop-entrypoint.sh
SHARED_DIRS        ?= $(WORK_DIR)

BUILD_IMAGE        ?= $(CONTAINER_DIR)/build-image
DIRECTORIES        ?= $(CONTAINER_DIR)/directories

HELP_MSG          += \trun-develop              Run\
	a container from the ${IMAGE_NAME} image\n
HELP_MSG          += \tbuild-image              Build\
	the docker images ${IMAGE_NAME} with the required dependencies\n

directories: $(DIRECTORIES)

$(DIRECTORIES):
	$(foreach dir, $(SHARED_DIRS), mkdir -p $(dir);)
	@touch $@

build-image: $(BUILD_IMAGE)

$(BUILD_IMAGE): $(DOCKER_FILE) $(DOCKER_SCRIPTS)
	@printf "docker build -t $(IMAGE_NAME)                          \n"
	@printf "   --build-arg DOCKER_ENTRYPOINT=$(DOCKER_ENTRYPOINT)  \n"
	@printf "   --file $(DOCKER_FILE) .                             \n"

	@printf "Are you sure you want to proceed? [Y/n] : "
	@read -r response;                                         \
	if [ "$$response" != "Y" ]; then                           \
		echo "Abroted. To proceed you need approve.";      \
		exit 1;                                            \
	fi

	@docker build -t $(IMAGE_NAME)                             \
		--build-arg DOCKER_ENTRYPOINT=$(DOCKER_ENTRYPOINT) \
		--file $(DOCKER_FILE) .
	@touch $@

run-develop: build-image directories
	@printf "docker run -it --rm                               \n"
	@printf "   --name $(CONTAINER_NAME)                       \n"
	@printf "   --network host                                 \n"
	@printf "   --env USERNAME=$(USERNAME)                     \n"
	@printf "   --env USER_UID=$(USER_UID)                     \n"
	@printf "   --env USER_GID=$(USER_GID)                     \n"
	@printf "   --env WORK_DIR=$(WORK_DIR)                     \n"
	@printf " $(foreach dir, $(SHARED_DIRS),  --volume $(dir):$(dir) \n)"
	@printf "$(IMAGE_NAME)\n\n"

	@echo -n "Are you sure you want to proceed? [Y/n] : "
	@read -r response;                                       \
	if [ "$$response" != "Y" ]; then                         \
		echo "Abroted. To proceed you need approve.";    \
		exit 1;                                          \
	fi                                                       \

	@docker run -it --rm                                     \
		--name $(CONTAINER_NAME)                         \
		--network host                                   \
		--env AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)     \
		--env AWS_SECRET_ACCESS_KEY=$(AWS_ACCESS_KEY_ID) \
		--env USERNAME=$(USERNAME)                       \
		--env USER_UID=$(USER_UID)                       \
		--env USER_GID=$(USER_GID)                       \
		--env WORK_DIR=$(WORK_DIR)                       \
		$(foreach dir, $(SHARED_DIRS), -v $(dir):$(dir)) \
		$(IMAGE_NAME)

clean-image:
	@docker rmi --force $(IMAGE_NAME)
	@rm -rf $(BUILD_IMAGE)
	@rm -rf $(DIRECTORIES)
