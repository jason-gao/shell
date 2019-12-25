#!/bin/bash

cp docker_install.sh docker_install.sh.bak
wget  -c https://get.docker.com/ -O docker_install.sh

cp install_golang_dep.sh install_golang_dep.sh.bak
wget -c https://raw.githubusercontent.com/golang/dep/master/install.sh -O install_golang_dep.sh