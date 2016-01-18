#!/bin/bash
user=$1
pass=$2
host=$3
dates=$(date +"%Y-%m-%d_%H-%M-%S")
backupremotedir='REMOTE_BACKUP_DIR'
echo '---MySQL Backup Starting..---'
mysqldump -u DB_NAME -p"DB_PASSWORD" DB_NAME | gzip -9 > /PATH/$dates.sql.gz
echo "---MySQL Backup File: $dates.sql.gz---"
echo '---MySQL Backup Finished!---'
echo '---MySQL Backup remote server old backup files delete starting..---'
/usr/bin/ftp -v -n $host <<END_OF_DELETE
user $user $pass
cd $backupremotedir
prompt
mdelete *
bye
END_OF_DELETE
echo '---MySQL Backup remote server old backup files delete finished!---'
echo '---MySQL Backup remote server upload starting..---'
/usr/bin/ftp -v -n $host <<END_OF_UPLOAD
user $user $pass
cd $backupremotedir
put $dates.sql.gz
bye
END_OF_UPLOAD
echo '---MySQL Backup remoter server upload finished!---'
echo '---MySQL Backup deleting..---'
rm -f $dates.sql.gz
echo "---MySQL Backup : $dates.sql.gz file deleted!---"

