FROM ubuntu:focal

RUN apt-get update
RUN apt-get install --no-install-recommends -y tzdata
RUN apt-get install --no-install-recommends -y \
  autoconf automake pkg-config build-essential cmake \
  liblua5.1-0-dev libmysqlclient-dev libxml2-dev libgmp3-dev \
  libboost-filesystem-dev libboost-regex-dev libboost-thread-dev

WORKDIR /home/otserv860

COPY . .
RUN mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(grep processor /proc/cpuinfo | wc -l)
RUN mv theforgottenserver ..
