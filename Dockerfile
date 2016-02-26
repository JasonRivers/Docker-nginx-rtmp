FROM alpine:latest
MAINTAINER Jason Rivers <docker@jasonrivers.co.uk>

RUN	apk update		&&	\
	apk add				\
		openssl			\
		libstdc++		\
		ca-certificates		\
		pcre


ADD	nginx.tar.gz /opt/

EXPOSE 1935

CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
