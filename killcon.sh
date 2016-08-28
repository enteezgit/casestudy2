#!/bin/bash
docker kill sqlNodeTEST dataNodeTEST2  dataNodeTEST1 mgmtNodeTEST
docker rm sqlNodeTEST dataNodeTEST2  dataNodeTEST1 mgmtNodeTEST
