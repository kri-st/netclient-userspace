FROM golang:1.19 as builder
# add glib support daemon manager
WORKDIR /usr/src/app

RUN git clone https://git.zx2c4.com/wireguard-go && \
    cd wireguard-go && \
    make && \
    make install

ENV WITH_WGQUICK=yes
RUN git clone https://git.zx2c4.com/wireguard-tools && \
    cd wireguard-tools && \
    cd src && \
    make && \
    make install
