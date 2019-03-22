#!/bin/bash

REPO_ROOT=`git rev-parse --show-toplevel`
COMMIT_SHA=`git rev-parse --short HEAD`
pushd $REPO_ROOT
echo ${build_flag}
docker build -f docker/Dockerfile -t qlcchain/oracle:latest .
popd
