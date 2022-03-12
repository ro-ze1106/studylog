#!/bin/sh
set -e
rm -f /studylog/tmp/pids/server.pids
exec "$@"