#!/bin/bash

# exit if any command returns a nonzero exit code
set -e

# Prepare log files # and start outputting logs to stdout
mkdir -p /srv/logs
touch /srv/logs/gunicorn.log
touch /srv/logs/access.log
touch /srv/logs/error.log
tail -n 0 -f /srv/logs/*.log &

# Start Gunicorn processes
echo "Starting Gunicorn"
gunicorn wsgi:app \
    --bind 0.0.0.0:8000 \
    --log-level=info \
    --enable-stdio-inheritance \
    --capture-output \
    --log-file=/srv/logs/gunicorn.log \
    --access-logfile=/srv/logs/access.log \
    --error-logfile=/srv/logs/error.log \
    "$@"
