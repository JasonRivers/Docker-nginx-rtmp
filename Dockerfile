FROM alpine:latest as builder
MAINTAINER Jason Rivers <docker@jasonrivers.co.uk>

ENV NGINX_VERSION 1.9.15

RUN	apk update		&&	\
	apk add				\
		git			\
		gcc			\
		binutils-libs		\
		binutils		\
		gmp			\
		isl			\
		libgomp			\
		libatomic		\
		libgcc			\
		openssl			\
		pkgconf			\
		pkgconfig		\
		mpfr3			\
		mpc1			\
		libstdc++		\
		ca-certificates		\
		libssh2			\
		curl			\
		expat			\
		pcre			\
		musl-dev		\
		libc-dev		\
		pcre-dev		\
		zlib-dev		\
		openssl-dev		\
		make


RUN	cd /tmp/									&&	\
	wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz			&&	\
	git clone https://github.com/arut/nginx-rtmp-module.git

RUN	cd /tmp										&&	\
	tar xzf nginx-${NGINX_VERSION}.tar.gz						&&	\
	cd nginx-${NGINX_VERSION}							&&	\
	./configure										\
		--prefix=/opt/nginx								\
		--with-http_ssl_module								\
		--add-module=../nginx-rtmp-module					&&	\
	make										&&	\
	make install

FROM alpine:latest
RUN apk update		&& \
	apk add			   \
		openssl		   \
		libstdc++	   \
		ca-certificates	   \
		pcre

COPY --from=0 /opt/nginx /opt/nginx
ADD nginx.conf /opt/nginx/conf/nginx.conf

EXPOSE 1935
EXPOSE 8080

CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]

