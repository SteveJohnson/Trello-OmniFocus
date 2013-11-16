#!/bin/bash

if [ -z "$1" ];then
	echo "Usage: $0 local_dir"
	exit 1
fi

LOCAL_DIR=$1
WORKING_DIR=`pwd`

REMOTE_HOST=conquerllc.com
REMOTE_USER=root
REMOTE_WEB_DIR=/usr/share/nginx/www
REMOTE_DIR=trello-omnifocus

NOTIFIER_OPEN_URL="http://$REMOTE_HOST/$REMOTE_DIR"

echo "------- Deployment Started at "`date`"-------"
echo "Deploying contents of '"$LOCAL_DIR"' to '"$REMOTE_DIR"' on $REMOTE_HOST as user $REMOTE_USER"
rsync -av $LOCAL_DIR/ $REMOTE_USER@$REMOTE_HOST:$REMOTE_WEB_DIR/$REMOTE_DIR/

if [ -n "`which growlnotify`" ]; then
	growlnotify -t "Deployed ${WORKING_DIR##*/}/$LOCAL_DIR" -m "At `date`" --appIcon "Google Chrome" --url "$NOTIFIER_OPEN_URL"
elif [ -n "`which terminal-notifier`" ]; then
	terminal-notifier -title "Deployed ${WORKING_DIR##*/}/$LOCAL_DIR" -subtitle "At `date`" --appIcon "Google Chrome" -open "$NOTIFIER_OPEN_URL"
fi

echo "------- Deployment Finished at "`date`"-------"


