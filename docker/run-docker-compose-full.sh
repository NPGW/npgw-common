#!/bin/bash

IMAGE_VERSION=0.9.2509162104-draft
export IMAGE_VERSION

docker compose -f ./docker-compose-full.yml up