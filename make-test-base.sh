#!/usr/bin/env bash

if ! (docker images | grep test-base | grep -v grep) ; then
  docker build -t test-base -f Dockerfile.test-base .
fi
