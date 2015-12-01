FROM linuxserver/baseimage.python
MAINTAINER smdion <me@seandion.com> ,Sparklyballs <sparklyballs@linuxserver.io>

ENV BEETSDIR /config
ENV APTLIST="ffmpeg lame libav-tools libchromaprint-tools libjpeg8-dev libopenjpeg-dev libpng12-dev libyaml-dev mp3gain python2.7"

RUN add-apt-repository ppa:fkrull/deadsnakes-python2.7 && \
add-apt-repository ppa:mc3man/trusty-media && \
apt-get update -q && \
apt-get install $APTLIST -qy && \
pip install -U pyacoustid && \
pip install -U pylast && \
pip install -U flask && \
pip install -U pillow && \
pip install -U beets && \
apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

#Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
ADD defaults/ /defaults/
RUN chmod -v +x /etc/service/*/run /etc/my_init.d/*.sh

# Volumes and Ports
VOLUME /config /downloads /music
EXPOSE 8337

