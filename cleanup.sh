#!/bin/bash

if [ "$(docker ps -a -q)" ]; then
  docker container stop $(docker ps -a -q)
  docker container rm $(docker ps -a -q)
fi