FROM golang:1.19 as builder
# add glib support daemon manager
WORKDIR /usr/src/app

# Pull wireguard-go and build
RUN git clone https://git.zx2c4.com/wireguard-go && \
    cd wireguard-go && \
    make && \
    make install

# Pull wireguard tools and build
ENV WITH_WGQUICK=yes
RUN git clone https://git.zx2c4.com/wireguard-tools && \
    cd wireguard-tools && \
    cd src && \
    make && \
    make install

