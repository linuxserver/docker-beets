[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/index.php/irc/
[podcasturl]: https://www.linuxserver.io/index.php/category/podcast/

[![linuxserver.io](https://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/beets
[![](https://images.microbadger.com/badges/image/linuxserver/beets.svg)](http://microbadger.com/images/linuxserver/beets "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/beets.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/beets.svg)][hub][![Build Status](http://jenkins.linuxserver.io:8080/buildStatus/icon?job=Dockers/LinuxServer.io/linuxserver-beets)](http://jenkins.linuxserver.io:8080/job/Dockers/job/LinuxServer.io/job/linuxserver-beets/)
[hub]: https://hub.docker.com/r/linuxserver/beets/

[Beets][beetsurl] is a music library manager and not, for the most part, a music player. It does include a simple player plugin and an experimental Web-based player, but it generally leaves actual sound-reproduction to specialized tools.

[![beets](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/beets-icon.png)][beetsurl]
[beetsurl]: http://beets.io/

## Usage

```
docker create \
--name=beets \
-v <path to data>:/config \
-e PGID=<gid> -e PUID=<uid>  \
-p 1234:1234 \
linuxserver/beets
```

**Parameters**

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

## Info

* To monitor the logs of the container in realtime `docker logs -f beets`.


## Versions

+ **24.09.16:** Rebase to alpine linux.
+ **10.09.16:** Add layer badges to README.
+ **05.01.16:** Change ffpmeg repository, other version crashes container
+ **06.11.15:** Initial Release
+ **29.11.15:** Take out term setting, causing issues with key entry for some users

