FROM alpine:latest
MAINTAINER Jason Rivers <docker@jasonrivers.co.uk>

RUN	apk update		&&	\
	apk add				\
		openssl			\
		libstdc++		\
		ca-certificates		\
		pcre


ADD	nginx.tar.gz /opt/
#RUN	cd /tmp										&&	\
#	mkdir -p /opt									&&	\
#	tar xzf nginx.tar.gz -C /opt

EXPOSE 1935

CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
