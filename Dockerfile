FROM lsiobase/alpine:3.9

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BEETS_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies --upgrade \
	cmake \
	ffmpeg-dev \
	fftw-dev \
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
 apk add --no-cache --upgrade \
	curl \
	expat \
	ffmpeg \
	ffmpeg-libs \
	fftw \
	flac \
	gdbm \
	gst-plugins-good \
	gstreamer \
	jpeg \
	jq \
	lame \
	libffi \
	libpng \
	mpg123 \
	nano \
	openjpeg \
	py3-gobject3 \
	py3-pip \
	py3-pylast \
	python3 \
	sqlite-libs \
	tar \
	wget && \
 echo "**** compile mp3gain ****" && \
 mkdir -p \
	/tmp/mp3gain-src && \
 curl -o \
 /tmp/mp3gain-src/mp3gain.zip -sL \
	https://sourceforge.net/projects/mp3gain/files/mp3gain/1.6.1/mp3gain-1_6_1-src.zip && \
 cd /tmp/mp3gain-src && \
 unzip -qq /tmp/mp3gain-src/mp3gain.zip && \
 sed -i "s#/usr/local/bin#/usr/bin#g" /tmp/mp3gain-src/Makefile && \
 make && \
 make install && \
 echo "**** compile mp3val ****" && \
 mkdir -p \
	/tmp/mp3val-src && \
 curl -o \
 /tmp/mp3val-src/mp3val.tar.gz -sL \
	https://downloads.sourceforge.net/mp3val/mp3val-0.1.8-src.tar.gz && \
 cd /tmp/mp3val-src && \
 tar xzf /tmp/mp3val-src/mp3val.tar.gz --strip 1 && \
 make -f Makefile.linux && \
 cp -p mp3val /usr/bin && \
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
 if [ -z ${BEETS_VERSION+x} ]; then \
	BEETS_VERSION=$(curl -sL  https://pypi.python.org/pypi/beets/json \
	|jq -r '. | .info.version'); \
 fi && \
 pip3 install --no-cache-dir -U \
	beautifulsoup4 \
	beets==${BEETS_VERSION} \
	beets-extrafiles \
	discogs-client \
	flask \
	pillow \
	pip \
	pyacoustid \
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
