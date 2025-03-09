#!/bin/bash
# reset.sh: Completely reset Docker to a clean state.
# WARNING: This script is destructive. It will remove all Docker containers,
# images, volumes, and networks. Use with caution!

set -e

echo "Stopping and removing Docker Compose containers, networks, and volumes..."
docker compose down --volumes --remove-orphans

echo "Pruning stopped containers..."
docker container prune -f

echo "Pruning unused images..."
docker image prune -a -f

echo "Pruning unused volumes..."
docker volume prune -f

echo "Pruning unused networks..."
docker network prune -f

echo "Docker has been reset to a clean state."
