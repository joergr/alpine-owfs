# STEP 1 build owfs
FROM alpine:3.9 as owfsbuilder

RUN apk update; \
    apk add alpine-keys; \
    apk add bash automake make git rsync tar python py-setuptools \
       gcc g++ binutils libgcc libstdc++ libgfortran \
       readline readline-dev python-dev dev86 \
       m4 libtool autoconf swig fuse fuse-dev perl-dev \
       linux-headers libftdi1-dev

RUN git clone https://github.com/owfs/owfs owfs-code

RUN cd owfs-code; \
    git pull; \
    ./bootstrap; \
    ./configure; \ 
    make; \
    make install

COPY owfs.conf /etc/owfs.conf


# start from scratch
FROM alpine:3.9
MAINTAINER Jörg Ruwe<joru@gmail.com>

COPY --from=owfsbuilder /opt/owfs /opt/owfs
COPY owfs.conf /etc/owfs.conf
COPY owfs-wrapper.sh /app.sh

RUN apk add --update fuse libftdi1 libusb

CMD ["/app.sh"]
