# graphdb4knora
Dockerized GraphDB for knora based on `ubuntu`

We build an off-the shelf graphdb instance (it can be replaced by another anytime)

## Download graphdb

let's say `graphdb-se-8.0.3-dist.zip`, in the same directory as the Dockerfile.
Adapt this script to find your graphdb version:
```sh
cat Dockerfile.prototype | sed 's#%GRAPHDB%#graphdb-se-8.0.3#' > Dockerfile
```

## Local data

We put only the graphdb code in the container, the rest in the host's file system.  
These items have different lifespan: _data_, _licence_, graphdb version, _consistency rules file_ ([KnoraRules.pie](https://github.com/dhlab-basel/Knora/blob/develop/webapi/scripts/KnoraRules.pie)).  
So we expect to have on the host, a local folder like:

```sh
graphdb/
graphdb.license
KnoraRules.pie
```



If missing:

- `graphdb/` subfolder is created at runtime

- `graphdb.license`  can be missing, it will generate an error in the log, but graphdb will work without a license

  ​

This local folder (i.e. `/my/data/dir`) is mounted with this docker arguments: `-v /my/data/dir:/graphdb`. 

### Note about SELinux

```
  $ sudo su -c "setenforce 0"
  $ sudo chcon -Rt svirt_sandbox_file_t </my/data/dir>
  $ sudo su -c "setenforce 1"
  $ sudo mkdir -p </my/data/dir>
```

# build and run

```sh
  $ sudo docker build -t graphdb-image .
  $ sudo docker run -p <exposed port>:7200 -v </my/data/dir>:/graphdb --name graphdb-container -d graphdb-image
```
To ease the release (and roll-back) process, it is recommended to version images and containers, for exemple:

```sh
  $ sudo docker build -t knora/graphdb:dev-20170613 .
  $ sudo docker run -p 7200:7200 -v /my/data/dir:/graphdb --name graphdb-20170613 -d knora/graphdb:dev-20170613
```

To match the rights of the local files and the user graphdb runs as in the container, you can pass a user `uid` and `gid` to be used:

```sh
$ sudo docker run -p 7200>:7200 -v /my/data/dir:/graphdb --name graphdb-20170613 -d knora/graphdb:dev-20170613 `id -u dbuser` `id -g dbuser`
```

