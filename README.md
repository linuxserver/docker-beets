[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring :-

 * regular and timely application updates
 * easy user mappings (PGID, PUID)
 * custom base image with s6 overlay
 * weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
 * regular security updates

Find us at:
* [Discord](https://discord.gg/YWrKVTn) - realtime support / chat with the community and the team.
* [IRC](https://irc.linuxserver.io) - on freenode at `#linuxserver.io`. Our primary support channel is Discord.
* [Blog](https://blog.linuxserver.io) - all the things you can do with our containers including How-To guides, opinions and much more!
* [Podcast](https://anchor.fm/linuxserverio) - on hiatus. Coming back soon (late 2018).

# [linuxserver/beets](https://github.com/linuxserver/docker-beets)
[![](https://img.shields.io/discord/354974912613449730.svg?logo=discord&label=LSIO%20Discord&style=flat-square)](https://discord.gg/YWrKVTn)
[![](https://images.microbadger.com/badges/version/linuxserver/beets.svg)](https://microbadger.com/images/linuxserver/beets "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/linuxserver/beets.svg)](https://microbadger.com/images/linuxserver/beets "Get your own version badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/beets.svg)
![Docker Stars](https://img.shields.io/docker/stars/linuxserver/beets.svg)
[![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Pipeline-Builders/docker-beets/master)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-beets/job/master/)
[![](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/beets/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/beets/latest/index.html)

[Beets](http://beets.io/) is a music library manager and not, for the most part, a music player. It does include a simple player plugin and an experimental Web-based player, but it generally leaves actual sound-reproduction to specialized tools.

[![beets](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/beets-icon.png)](http://beets.io/)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list) and our announcement [here](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/). 

Simply pulling `linuxserver/beets` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v6-latest |


## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=beets \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -p 8337:8337 \
  -v </path/to/appdata/config>:/config \
  -v </path/to/music/library>:/music \
  -v </path/to/ingest>:/downloads \
  --restart unless-stopped \
  linuxserver/beets
```


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  beets:
    image: linuxserver/beets
    container_name: beets
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - </path/to/appdata/config>:/config
      - </path/to/music/library>:/music
      - </path/to/ingest>:/downloads
    ports:
      - 8337:8337
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 8337` | Application WebUI |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-v /config` | Configuration files. |
| `-v /music` | Music library |
| `-v /downloads` | Non processed music |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```


&nbsp;


## Support Info

* Shell access whilst the container is running: `docker exec -it beets /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f beets`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' beets`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/beets`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.  
  
Below are the instructions for updating containers:  
  
### Via Docker Run/Create
* Update the image: `docker pull linuxserver/beets`
* Stop the running container: `docker stop beets`
* Delete the container: `docker rm beets`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start beets`
* You can also remove the old dangling images: `docker image prune`

### Via Taisun auto-updater (especially useful if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one shot:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock taisun/updater \
  --oneshot beets
  ```
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull beets`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d beets`
* You can also remove the old dangling images: `docker image prune`

## Versions

* **07.02.19:** - Add fftw-dev build dependency for chromaprint.
* **28.01.19:** - Add pipeline logic and multi arch.
* **15.08.18:** - Rebase to alpine 3.8, use alpine repo version of pylast.
* **12.08.18:** - Add requests pip package.
* **04.03.18:** - Upgrade mp3gain to 1.6.1.
* **02.01.18:** - Deprecate cpu_core routine lack of scaling.
* **27.12.17:** - Add beautifulsoup4 pip package.
* **06.12.17:** - Rebase to alpine linux 3.7.
* **25.05.17:** - Rebase to alpine linux 3.6.
* **06.02.17:** - Rebase to alpine linux 3.5.
* **16.01.17:** - Add packages required for replaygain.
* **24.12.16:** - Add [beets-copyartifacts](https://github.com/sbarakat/beets-copyartifacts) plugin.
* **07.12.16:** - Edit cmake options for chromaprint, should now build and install fpcalc, add gstreamer lib
* **14.10.16:** - Add version layer information.
* **01.10.16:** - Add nano and editor variable to allow editing of the config from the container command line.
* **30.09.16:** - Fix umask.
* **24.09.16:** - Rebase to alpine linux.
* **10.09.16:** - Add layer badges to README.
* **05.01.16:** - Change ffpmeg repository, other version crashes container
* **06.11.15:** - Initial Release
* **29.11.15:** - Take out term setting, causing issues with key entry for some users
