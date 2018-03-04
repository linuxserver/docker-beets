[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/irc/
[podcasturl]: https://www.linuxserver.io/podcast/
[appurl]: http://beets.io/
[hub]: https://hub.docker.com/r/linuxserver/beets/

[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/beets
[![](https://images.microbadger.com/badges/version/linuxserver/beets.svg)](https://microbadger.com/images/linuxserver/beets "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/linuxserver/beets.svg)](https://microbadger.com/images/linuxserver/beets "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/beets.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/beets.svg)][hub][![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Builders/x86-64/x86-64-beets)](https://ci.linuxserver.io/job/Docker-Builders/job/x86-64/job/x86-64-beets/)

[Beets][appurl] is a music library manager and not, for the most part, a music player. It does include a simple player plugin and an experimental Web-based player, but it generally leaves actual sound-reproduction to specialized tools.

[![beets](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/beets-icon.png)][appurl]

## Usage

```
docker create \
--name=beets \
-v <path to data>:/config \
-e PGID=<gid> -e PUID=<uid>  \
-p 1234:1234 \
linuxserver/beets
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-p 8337` - the port(s)
* `-v /config` - Configuration files
* `-v /music` - Music library location
* `-v /downloads` - Non-processed music
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it beets /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application 

Edit the config file in /config

To edit the config from within the container use `beet config -e`

For a command prompt as user abc `docker exec -it -u abc beets bash`

See [Beets][appurl] for more info.

Contains [beets-copyartifacts](https://github.com/sbarakat/beets-copyartifacts) plugin, [configuration details](https://github.com/sbarakat/beets-copyartifacts#configuration)

## Info

* To monitor the logs of the container in realtime `docker logs -f beets`.

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' beets`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/beets`


## Versions

+ **04.03.18:** Upgrade mp3gain to 1.6.1.
+ **02.01.18:** Deprecate cpu_core routine lack of scaling.
+ **27.12.17:** Add beautifulsoup4 pip package.
+ **06.12.17:** Rebase to alpine linux 3.7.
+ **25.05.17:** Rebase to alpine linux 3.6.
+ **06.02.17:** Rebase to alpine linux 3.5.
+ **16.01.17:** Add packages required for replaygain.
+ **24.12.16:** Add [beets-copyartifacts](https://github.com/sbarakat/beets-copyartifacts) plugin.
+ **07.12.16:** Edit cmake options for chromaprint, should now build and install fpcalc, add gstreamer lib
+ **14.10.16:** Add version layer information.
+ **01.10.16:** Add nano and editor variable -
to allow editing of the config from the container command line.
+ **30.09.16:** Fix umask.
+ **24.09.16:** Rebase to alpine linux.
+ **10.09.16:** Add layer badges to README.
+ **05.01.16:** Change ffpmeg repository, other version crashes container
+ **06.11.15:** Initial Release
+ **29.11.15:** Take out term setting, causing issues with key entry for some users
