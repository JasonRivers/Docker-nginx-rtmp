FROM debian:latest
MAINTAINER Jason Rivers <docker@jasonrivers.co.uk>

ENV	DEBIAN_FRONTEND             noninteractive

RUN	apt-get update				&&	\
	apt-get install --assume-yes			\
		git					\
		wget					\
		build-essential				\
		libpcre3				\
		libpcre3-dev				\
		libssl-dev			&&	\
	apt-get clean


RUN	cd /tmp/									&&	\
	wget http://nginx.org/download/nginx-1.9.11.tar.gz				&&	\
	git clone https://github.com/arut/nginx-rtmp-module.git

RUN	cd /tmp										&&	\
	tar xf nginx-1.9.11.tar.gz							&&	\
	cd nginx-1.9.11									&&	\
	./configure										\
		--prefix=/opt/nginx								\
		--with-http_ssl_module								\
		--add-module=../nginx-rtmp-module					&&	\
	make										&&	\
	make install

RUN	echo "rtmp {" >> /opt/nginx/conf/nginx.conf					&&	\
	echo "	server {" >> /opt/nginx/conf/nginx.conf					&&	\
	echo "		listen 1935;" >> /opt/nginx/conf/nginx.conf			&&	\
	echo "		chunk_size 4096;" >> /opt/nginx/conf/nginx.conf			&&	\
	echo "		application live {" >> /opt/nginx/conf/nginx.conf		&&	\
	echo "			live on;" >> /opt/nginx/conf/nginx.conf			&&	\
	echo "			record off;" >> /opt/nginx/conf/nginx.conf		&&	\
	echo "		}" >> /opt/nginx/conf/nginx.conf				&&	\
	echo "		application testing {" >> /opt/nginx/conf/nginx.conf		&&	\
	echo "			live on;" >> /opt/nginx/conf/nginx.conf			&&	\
	echo "			record off;" >> /opt/nginx/conf/nginx.conf		&&	\
	echo "		}" >> /opt/nginx/conf/nginx.conf				&&	\
	echo "	}" >> /opt/nginx/conf/nginx.conf					&&	\
	echo "}" >> /opt/nginx/conf/nginx.conf

EXPOSE 1935

CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
