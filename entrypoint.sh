#!/bin/bash

set -e

mkdir -p /app/data

cd /app

echo "========== Argo-Komari Starting =========="

restore_backup() {

    if [ ! -f /app/data/komari.db ]; then

        echo "No local data found"

        echo "Trying restore from GitHub..."

        rm -rf /tmp/backup_restore

        git clone https://${GH_USER}:${GH_PAT}@github.com/${GH_USER}/${GH_REPO}.git /tmp/backup_restore || true

        cd /tmp/backup_restore || return

        FILE=$(ls -t *.tar.gz 2>/dev/null | head -n 1)

        if [ -n "$FILE" ]; then

            echo "Restoring backup: $FILE"

            tar xzf "$FILE" -C /

            echo "Restore completed"

        else

            echo "No backup file found"

        fi

        cd /app
    fi
}

backup_loop() {

    while true
    do

        sleep 86400

        echo "Starting backup..."

        FILE="komari-$(date +%F-%H-%M-%S).tar.gz"

        tar czf /tmp/$FILE /app/data

        rm -rf /tmp/backup_push

        git clone https://${GH_USER}:${GH_PAT}@github.com/${GH_USER}/${GH_REPO}.git /tmp/backup_push || continue

        cd /tmp/backup_push

        cp /tmp/$FILE .

        echo "Cleaning old backups..."

        ls -t *.tar.gz | tail -n +6 | xargs rm -f || true

        git config user.email "${GH_EMAIL}"
        git config user.name "${GH_USER}"

        git add .

        git commit -m "backup $(date)" || true

        git push

        echo "Backup completed"

        cd /app

    done
}

restore_backup || true

backup_loop &

echo "Starting Komari..."

/usr/local/bin/komari server -l 0.0.0.0:25774 &

sleep 10

echo "Starting Cloudflare Tunnel..."

cloudflared tunnel run --token "$ARGO_TOKEN"