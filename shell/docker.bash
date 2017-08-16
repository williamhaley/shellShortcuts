# Docker aliases

function docker-nuclear()
{
	docker stop $(docker ps -a -q)
	docker rm $(docker ps -a -q)
	docker rmi -f $(docker images -q)
}

function docker-clean()
{
	echo "DOES NOTHING"
}
