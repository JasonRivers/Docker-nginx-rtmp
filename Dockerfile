FROM alpine:latest as builder
MAINTAINER Jason Rivers <docker@jasonrivers.co.uk>

ARG NGINX_VERSION=1.15.3
ARG NGINX_RTMP_VERSION=1.2.1


RUN	apk update		&&	\
	apk add				\
		git			\
		gcc			\
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
		curl			\
		make


RUN	cd /tmp/									&&	\
	curl --remote-name http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz			&&	\
	git clone https://github.com/arut/nginx-rtmp-module.git -b v${NGINX_RTMP_VERSION}

RUN	cd /tmp										&&	\
	tar xzf nginx-${NGINX_VERSION}.tar.gz						&&	\
	cd nginx-${NGINX_VERSION}							&&	\
	./configure										\
		--prefix=/opt/nginx								\
		--with-http_ssl_module								\
		--with-cc-opt="-Wimplicit-fallthrough=0"					\
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
COPY --from=0 /tmp/nginx-rtmp-module/stat.xsl /opt/nginx/conf/stat.xsl
RUN rm /opt/nginx/conf/nginx.conf
ADD run.sh /

EXPOSE 1935
EXPOSE 8080

CMD /run.sh

