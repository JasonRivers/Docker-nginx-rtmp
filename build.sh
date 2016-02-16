#!/bin/bash

rm -f nginx.tar.gz

cd build

docker build -t nginx-build .

cd ..

DID=`docker create nginx-build`

docker cp ${DID}:/tmp/nginx.tar.gz ./

docker rm ${DID}
docker rmi nginx-build

docker build -t nginx-rtmp .


