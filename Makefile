include .env

TARGET=zopfli

.PHONY: bld
bld:
	@echo '$(DOCKER_IMAGE)'
	@export DOCKER_BUILDKIT=1;
	@docker buildx build -o type=docker \
  --target=$(TARGET) \
  --build-arg ZOPFLI_VER='$(ZOPFLI_VER)' \
  --tag='docker.pkg.github.com/$(REPO_OWNER)/$(REPO_NAME)/$(CONTAINER_NAME):$(VERSION)' \
  .

.PHONY: run
run: fixtures/inkscape.svgz

.PHONY: clean
clean:
	rm -f fixtures/inkscape.svgz


fixtures/inkscape.svgz: fixtures/inkscape.svg
	@cat $< | docker run \
  --rm \
  --name $(CONTAINER_NAME) \
  --interactive \
  docker.pkg.github.com/$(REPO_OWNER)/$(REPO_NAME)/$(CONTAINER_NAME):$(VERSION) > $@
	@echo  "  orginal size:  [ $$(wc -c $< | cut -d' ' -f1) ] "
	@echo  "  gzip bld size: [ $$(wc -c $@ | cut -d' ' -f1) ]"

.PHONY: help
help:
	@cat fixtures/inkscape.svg | docker run \
  --rm \
  --name $(CONTAINER_NAME) \
  --interactive \
  --entrypoint /usr/local/bin/zopfli \
  docker.pkg.github.com/$(REPO_OWNER)/$(REPO_NAME)/$(CONTAINER_NAME):$(VERSION)  -h
