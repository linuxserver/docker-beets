# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.21

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BEETS_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    build-base \
    cairo-dev \
    cargo \
    cmake \
    ffmpeg-dev \
    fftw-dev \
    git \
    gobject-introspection-dev \
    jpeg-dev \
    libpng-dev \
    mpg123-dev \
    openjpeg-dev \
    python3-dev && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    chromaprint \
    expat \
    ffmpeg \
    fftw \
    flac \
    gdbm \
    gobject-introspection \
    gst-plugins-good \
    gstreamer \
    imagemagick \
    jpeg \
    lame \
    libffi \
    libpng \
    mpg123 \
    nano \
    openjpeg \
    python3 \
    sqlite-libs && \
  echo "**** install beets ****" && \
  if [ -z ${BEETS_VERSION+x} ] ; then \
    BEETS_VERSION=$(curl -sX GET "https://api.github.com/repos/beetbox/beets/commits/master" \
    | jq -r .sha); \
  fi && \
  git clone https://github.com/beetbox/beets.git /tmp/beets && \
  cd /tmp/beets && \
  git checkout -f "${BEETS_VERSION}" && \
  echo "**** compile mp3gain ****" && \
  mkdir -p \
    /tmp/mp3gain-src && \
  curl -o \
    /tmp/mp3gain-src/mp3gain.zip -sL \
    https://sourceforge.net/projects/mp3gain/files/mp3gain/1.6.2/mp3gain-1_6_2-src.zip && \
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
  echo "**** install pip packages ****" && \
  python3 -m venv /lsiopy && \
  pip install -U --no-cache-dir \
    pip \
    setuptools \
    wheel && \
  echo "**** install beets ****" && \
  cd /tmp/beets && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.21/ . && \
  echo "**** install pip packages ****" && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.21/ \
    beautifulsoup4 \
    beets-extrafiles \
    beetcamp \
    python3-discogs-client \
    flask \
    PyGObject \
    pyacoustid \
    pylast \
    requests \
    requests_oauthlib \
    typing-extensions \
    unidecode && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/* \
    $HOME/.cache \
    $HOME/.cargo

# environment settings
ENV BEETSDIR="/config" \
EDITOR="nano" \
HOME="/config"

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8337
VOLUME /config
