# Run this as root.  Warning this will purge your system of everything apart from
# the docker and docker compose installation. So be very Careful !!!

docker stop $(docker ps -q) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true
docker rmi $(docker images -q) 2>/dev/null || true
docker volume rm $(docker volume ls -q) 2>/dev/null || true
docker network prune -f
docker system prune -a -f --volumes
