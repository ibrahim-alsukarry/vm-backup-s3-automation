#!/bin/bash

times=$( date '+%m-%d-%y_%H-%M-%S' )
backup_file=/home/ubuntu/vm-backup-project/bass-data
dest=/home/ubuntu/vm-backup-project/backup-data
filename=file-backup-$times.tar.gz
LOG_FILE="/home/ubuntu/vm-backup-project/backup-data/logfile.log"

S3_BUCKET="vm-backup-automation-7391"
FILE_TO_UPLOAD="$dest/$filename"

if ! command -v aws &> /dev/null
then
	echo "$(date '+%Y-%m-%d %H:%M:%S') AWS CLI is not installed. Please install it first." | tee -a "$LOG_FILE"
	exit 2
fi



	if [ -f "$dest/$filename" ]
	then
		echo " $(date '+%Y-%m-%d %H:%M:%S') ERROR file $dest/$filename already exists! " | tee -a "$LOG_FILE"
        else
		tar -czvf "$dest/$filename" "$backup_file"
		if [ $? -eq 0 ] 
		then
			echo " $(date '+%Y-%m-%d %H:%M:%S') Backup Completed Successfuly. Backup file: $dest/$filename " | tee -a "$LOG_FILE"
			aws s3 cp "$FILE_TO_UPLOAD" "s3://$S3_BUCKET/"
			if [ $? -eq 0 ] 
			then
				echo " $(date '+%Y-%m-%d %H:%M:%S') Upload to s3 completed: s3://$S3_BUCKET/" | tee -a "$LOG_FILE"
			else
				echo " $(date '+%Y-%m-%d %H:%M:%S') ERROR: S3 upload failed for $FILE_TO_UPLOAD" | tee -a "$LOG_FILE"
			fi
		else
			echo " $(date '+%Y-%m-%d %H:%M:%S') ERROR: Backup failed for $backup_file " | tee -a "$LOG_FILE"
			echo 
		fi
	fi




