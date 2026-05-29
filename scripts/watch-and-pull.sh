#!/bin/bash
while true; do
    git -C ~/git/ariadne-website fetch origin dev
    LOCAL=$(git -C ~/git/ariadne-website rev-parse dev)
    REMOTE=$(git -C ~/git/ariadne-website rev-parse origin/dev)
    if [ "$LOCAL" != "$REMOTE" ]; then
        echo "New commit detected, pulling..."
        git -C ~/git/ariadne-website pull
    fi
    sleep 10
done
