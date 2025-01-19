#!/bin/bash
set -e

REMOTE_LOGIN=$1
DB_NAME=$2
DB_USER=$3
DB_PASS=$4
BACKUP_DIR=$5
DECOMPRESS=$6

DATE=$(date +%Y%m%d_%H%M%S)
REMOTE_BACKUP_FILE="/tmp/${DB_NAME}_backup_${DATE}.sql"
COMPRESSED_FILE="${REMOTE_BACKUP_FILE}.zst"
LOCAL_FILE="${BACKUP_DIR}/${DB_NAME}_backup_${DATE}.sql.zst"

echo "Creating remote backup directory if needed..."
ssh "${REMOTE_LOGIN}" "mkdir -p /tmp"

echo "Creating MySQL backup on remote server..."
ssh "${REMOTE_LOGIN}" << EOF
  export MYSQL_PWD=${DB_PASS}
  mysqldump -u ${DB_USER} ${DB_NAME} > ${REMOTE_BACKUP_FILE}
  zstd -z ${REMOTE_BACKUP_FILE} -o ${COMPRESSED_FILE}
EOF

echo "Downloading compressed backup to local directory..."
mkdir -p "${BACKUP_DIR}"
rsync -avz "${REMOTE_LOGIN}:${COMPRESSED_FILE}" "${LOCAL_FILE}"

echo "Cleaning up remote files..."
ssh "${REMOTE_LOGIN}" "rm -f ${REMOTE_BACKUP_FILE} ${COMPRESSED_FILE}"

if [[ ${DECOMPRESS} == "true" ]]; then
  echo "Decompressing backup locally..."
  zstd -d "${LOCAL_FILE}" -o "${BACKUP_DIR}/${DB_NAME}_backup_${DATE}.sql"
fi

echo "Backup process complete!"
