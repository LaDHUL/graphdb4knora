release=20170613
container=graphdb-$(release)
image=platec/knora-graphdb-dev:$(release)
network=knora-test
alias=graphdb
graphdb_uid=$(shell /usr/bin/id -u graphdb)
graphdb_gid=$(shell /usr/bin/id -g graphdb)

check:
	docker ps | grep $(container)

stop:
	docker kill $(container)

rm: 
	docker rm $(container)

rmi: 
	docker rmi $(image)

build: 
	docker build -f Dockerfile -t $(image) .

run:
	docker run --net=$(network) --net-alias=$(alias) -d -p 7200:7200 -v /var/local/docker_space/knora-graphdb-dev:/graphdb --name=$(container) $(image) $(graphdb_uid) $(graphdb_gid)

start:
	docker start $(container)


