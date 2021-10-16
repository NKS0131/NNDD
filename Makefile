.PHONY: all build with-docker builder-img

all: build

build:
	@cd src && make

with-docker:
	@cd src && make with-docker

builder-img:
	@cd containers/builder && make
