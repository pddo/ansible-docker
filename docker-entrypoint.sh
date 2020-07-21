#!/bin/bash
set -e

eval `ssh-agent -s`

if [ ! -z "$SSH_KEY_FILE" ]; then
    ssh-add "/root/.ssh/$SSH_KEY_FILE"
fi

exec "$@"
