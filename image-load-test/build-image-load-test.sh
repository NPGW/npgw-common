#!/bin/bash

cd ../../
docker build -t load-test:latest -f ./docker/image-load-test/Dockerfile .