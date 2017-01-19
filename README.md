# graphdb4knora
Dockerized GraphDB for knora based on `centos`

We build an off-the shelf graphdb instance (it can be replaced by another anytime)

## Download graphdb

let's say `graphdb-se-7.1.0-dist.zip`, in the same directory as the Dockerfile.
Adapt this script to find your graphdb version:
```
cat Dockerfile.prototype | sed 's#%GRAPHDB%#graphdb-se-7.1.0#' > Dockerfile
```

## Local data

These items have different lifespan: data, licence, graphdb version, consistency rules file.
We put the graphdb only in the container, the rest in the host's file system.

The host files system has a directory: `%LOCAL_FS%`, it is mounted with this docker arguments: `-v %LOCAL_FS%:/graphdb`

Adapt this Dockerfile with:
```
cat Dockerfile | sed 's#%LOCAL_FS%#/my/data/dir#' > Dockerfile
```

Note about SELinux: if used, selinux has to allow the mount to be writeable by docker:
```
  $ sudo su -c "setenforce 0"
  $ sudo chcon -Rt svirt_sandbox_file_t </my/data/dir>
  $ sudo su -c "setenforce 1"
  $ sudo mkdir -p </my/data/dir>
```

### Licence
We expect to find a licence file named `%LOCAL_FS%/graphdb.licence`

### PIE file
Consistency file is also to be copied there: `%LOCAL_FS%/KnoraRules.pie`

# build and run

```
  $ sudo docker build -t platec/knora-test-graphdb .
  $ sudo docker run -p <exposed port>:7200 -v </my/data/dir>:/graphdb --name knora-test-graphdb -d platec/knora-test-graphdb
```

