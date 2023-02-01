FROM registry.access.redhat.com/ubi8/ubi:latest as builder

RUN yum install -y git python39 xz zip bzip2 which redhat-lsb-core
RUN git clone --depth 1 https://github.com/emscripten-core/emsdk.git
WORKDIR /emsdk
RUN ./emsdk install latest
RUN ./emsdk activate latest
ENV PATH=/emsdk:/emsdk/upstream/emscripten:/emsdk/node/14.18.2_64bit/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV EMSDK=/emsdk
ENV EMSDK_NODE=/emsdk/node/14.18.2_64bit/bin/node

RUN curl https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -e all -p /usr/local --version=0.11.2
