FROM alpine:3.8 as builder
LABEL maintainer="docker@jasonrivers.co.uk"

ARG NGINX_VERSION=1.15.3
ARG NGINX_RTMP_VERSION=1.2.1

RUN set -ex \
    && apk add -q --update --no-cache \
        git \
        gcc \
        binutils \
        gmp \
        isl \
        libgomp \
        libatomic \
        libgcc \
        openssl \
        pkgconf \
        pkgconfig \
        mpfr3 \
        mpc1 \
        libstdc++ \
        ca-certificates \
        libssh2 \
        curl \
        expat \
        pcre \
        musl-dev \
        libc-dev \
        pcre-dev \
        zlib-dev \
        openssl-dev \
        curl \
        make \
&& curl -sL http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o /tmp/nginx-${NGINX_VERSION}.tar.gz \
&& git clone https://github.com/arut/nginx-rtmp-module.git -b v${NGINX_RTMP_VERSION} /tmp/nginx-rtmp-module \
&& tar xzf /tmp/nginx-${NGINX_VERSION}.tar.gz -C /tmp \
&& cd /tmp/nginx-${NGINX_VERSION} \
&& ./configure \
    --prefix=/opt/nginx \
    --with-http_ssl_module \
    --add-module=../nginx-rtmp-module \
&& make \
&& make install

FROM alpine:3.8

RUN set -ex \
    && apk add -q --update --no-cache \
        openssl \
        libstdc++ \
        ca-certificates \
        pcre

COPY --from=builder /opt/nginx /opt/nginx
COPY --from=builder /tmp/nginx-rtmp-module/stat.xsl /opt/nginx/conf/stat.xsl
RUN rm /opt/nginx/conf/nginx.conf
COPY ./run.sh /

EXPOSE 1935
EXPOSE 8080

CMD ["/run.sh"]
