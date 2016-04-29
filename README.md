# Docker-nginx-rtmp
Docker image for an RTMP/HLS server running on nginx

NGINX Version 1.9.15
nginx-rtmp-module Version 1.1.7

### Configurations
This image exposes port 1935 for RTMP Steams and has 2 channels open "live" and "testing".

Live is also accessable via HLS on port 8080

It also exposes 8080 so you can access http://<your server ip>:8080/stat to see the streaming statistics.

The configuration file is in /opt/nginx/conf/

### Running

To run the container and bind the port 1935 to the host machine; run the following:
```
docker run -p 1935:1935 -p 8080:8080 jasonrivers/nginx-rtmp
```

### OBS Configuration
Under broadcast settigns, set the follwing parameters:
```
Streaming Service: Custom
Server: rtmp://<your server ip>/live
Play Path/Stream Key: mystream
```

### Watching the steam

In your favorite RTMP video player connect to the stream using the URL:
rtmp://&lt;your server ip&gt;/live/mystream
http://&lt;your server ip&gt;/hls/mystream.m3u8

### Tested players
 * VLC
 * omxplayer (Raspberry Pi)
