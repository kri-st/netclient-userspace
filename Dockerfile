FROM docker.io/library/golang:1.19 as builder
# add glib support daemon manager
WORKDIR /app

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

RUN git clone https://github.com/gravitl/netmaker.git && \
    cd netmaker && \
    go mod download 

WORKDIR /app/netmaker

ENV GO111MODULE=auto

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-w -s" -o netclient-app netclient/main.go

FROM registry.fedoraproject.org/fedora:36

LABEL maintainer="Krist van Besien <krist.vanbesien@gmail.com>"\
      description="userpsace netclient image"
      
COPY --from=builder /usr/bin/wireguard-go /usr/bin/wg* /usr/bin/
COPY --from=builder /app/netmaker/netclient-app ./netclient
COPY --from=builder /app/netmaker/scripts/netclient.sh .
RUN chmod 0755 netclient && chmod 0755 netclient.sh

ENV WG_QUICK_USERSPACE_IMPLEMENTATION=wireguard-go    
      
CMD ["/sbin/init"]
STOPSIGNAL SIGRTMIN+3
