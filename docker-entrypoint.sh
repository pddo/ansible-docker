#!/bin/bash
set -e

eval `ssh-agent -s`

if [ ! -z "$SSH_KEY_FILE_NAME" ]; then
    #TODO check key file existence before adding
    ssh-add "/root/.ssh/$SSH_KEY_FILE_NAME"
fi

exec "$@"
