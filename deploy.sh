#!/bin/bash

set -e

export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_deploy_script_key -o IdentitiesOnly=yes'

: "${DOCKER_DIR:?Environment variable DOCKER_DIR not set}"

cd "$DOCKER_DIR"

git fetch origin

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse @{u})

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "Repo changed. Deploying..."
    git pull
    docker compose -f docker-compose-main.yml up -d
else
    echo "No changes. Exiting."
fi
