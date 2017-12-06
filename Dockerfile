FROM lsiobase/alpine:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklybals"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	cmake \
	ffmpeg-dev \
	g++ \
	gcc \
	git \
	jpeg-dev \
	libpng-dev \
	make \
	openjpeg-dev \
	python2-dev && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	curl \
	expat \
	ffmpeg \
	ffmpeg-libs \
	gdbm \
	gst-plugins-good \
	gstreamer \
	jpeg \
	lame \
	libffi \
	libpng \
	nano \
	openjpeg \
	py2-gobject3 \
	py2-pip \
	python2 \
	sqlite-libs \
	tar \
	wget && \
 echo "**** compile mp3gain ****" && \
 mkdir -p \
	/tmp/mp3gain-src && \
 curl -o \
 /tmp/mp3gain-src/mp3gain.zip -L \
	https://sourceforge.net/projects/mp3gain/files/mp3gain/1.5.2/mp3gain-1_5_2_r2-src.zip && \
 cd /tmp/mp3gain-src && \
 unzip -qq /tmp/mp3gain-src/mp3gain.zip && \
 sed -i "s#/usr/local/bin#/usr/bin#g" /tmp/mp3gain-src/Makefile && \
 echo "**** attempt to set number of cores available for make to use ****" && \
 set -ex && \
 CPU_CORES=$( < /proc/cpuinfo grep -c processor ) || echo "failed cpu look up" && \
 if echo $CPU_CORES | grep -E  -q '^[0-9]+$'; then \
	: ;\
 if [ "$CPU_CORES" -gt 7 ]; then \
	CPU_CORES=$(( CPU_CORES  - 3 )); \
 elif [ "$CPU_CORES" -gt 5 ]; then \
	CPU_CORES=$(( CPU_CORES  - 2 )); \
 elif [ "$CPU_CORES" -gt 3 ]; then \
	CPU_CORES=$(( CPU_CORES  - 1 )); fi \
 else CPU_CORES="1"; fi && \
 make -j $CPU_CORES && \
 make install && \
 echo "**** compile chromaprint ****" && \
 git clone https://bitbucket.org/acoustid/chromaprint.git \
	/tmp/chromaprint && \
 cd /tmp/chromaprint && \
 cmake \
	-DBUILD_TOOLS=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX:PATH=/usr && \
 make -j $CPU_CORES && \
 set +ex && \
 make install && \
 echo "**** install pip packages ****" && \
 pip install --no-cache-dir -U \
	beets \
	beets-copyartifacts \
	flask \
	pillow \
	pip \
	pyacoustid \
	pylast \
	unidecode && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# environment settings
ENV BEETSDIR="/config" \
EDITOR="nano" \
HOME="/config"

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8337
VOLUME /config /downloads /music
