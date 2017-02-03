container=graphdb
image=platec/knora-test-graphdb-0.5
network=knora-test
alias=$(container)

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
	docker run --net=$(network) --net-alias=$(alias) -d -p 7200:7200 -v /var/local/docker_space/knora-test_graphdb:/graphdb --name=$(container) $(image)

start:
	docker start $(container)


