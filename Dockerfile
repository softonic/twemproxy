FROM alpine:3.7 as builder

ENV TWEMPROXY_URL https://github.com/twitter/twemproxy/archive/v0.4.1.tar.gz

RUN apk --no-cache add alpine-sdk autoconf automake curl libtool

RUN curl -L "$TWEMPROXY_URL" | tar xzf - && \
    TWEMPROXY_DIR=$(find / -maxdepth 1 -iname "twemproxy*" | sort | tail -1) && \
    cd $TWEMPROXY_DIR && \
    autoreconf -fvi && CFLAGS="-ggdb3 -O0" ./configure --enable-debug=full && make && make install

FROM alpine:3.7

COPY --from=builder /usr/local/sbin/nutcracker /usr/local/sbin/nutcracker
