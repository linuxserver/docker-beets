FROM lsiobase/alpine:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

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
	mpg123-dev \
	openjpeg-dev \
	python3-dev && \
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
	mpg123 \
	nano \
	openjpeg \
	py3-gobject3 \
	py3-pip \
	python3 \
	sqlite-libs \
	tar \
	wget && \
 echo "**** create symlink for pip ****" && \
 if \
	[ ! -e /usr/bin/pip ]; then \
	ln -s /usr/bin/pip3 /usr/bin/pip ; fi && \
 echo "**** compile mp3gain ****" && \
 mkdir -p \
	/tmp/mp3gain-src && \
 curl -o \
 /tmp/mp3gain-src/mp3gain.zip -L \
	https://sourceforge.net/projects/mp3gain/files/mp3gain/1.6.1/mp3gain-1_6_1-src.zip && \
 cd /tmp/mp3gain-src && \
 unzip -qq /tmp/mp3gain-src/mp3gain.zip && \
 sed -i "s#/usr/local/bin#/usr/bin#g" /tmp/mp3gain-src/Makefile && \
 make && \
 make install && \
 echo "**** compile chromaprint ****" && \
 git clone https://bitbucket.org/acoustid/chromaprint.git \
	/tmp/chromaprint && \
 cd /tmp/chromaprint && \
 cmake \
	-DBUILD_TOOLS=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX:PATH=/usr && \
 make && \
 make install && \
 echo "**** install pip packages ****" && \
 pip install --no-cache-dir -U \
	beautifulsoup4 \
	beets \
	beets-copyartifacts \
	discogs-client \
	flask \
	pillow \
	pip \
	pyacoustid \
	pylast \
	requests \
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
