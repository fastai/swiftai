default: build 

build:
	docker build -t swiftai .

shell: build
	docker run --privileged --user $(id -u):$(id -g) -p 127.0.0.1:8888:8888 -v $(PWD):/root/swiftai -it swiftai /bin/bash

jupyter: build
	docker run --privileged --user $(id -u):$(id -g) -p 127.0.0.1:8888:8888 -v $(PWD):/root/swiftai swiftai 

strip:
	./tools/fastai-nbstripout -d nbs/*
