#!/bin/bash

cd ../../
docker build -t api-test:latest -f ./docker/image-api-test/Dockerfile .