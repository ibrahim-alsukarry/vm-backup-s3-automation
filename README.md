# vm-backup-s3-automation

A Bash script that compresses EC2 instance data, logs each operation, and replicates the backups to Amazon S3. Scheduled with cron and authenticated through an IAM role attached to the instance — no access keys stored on the machine.

## How it works

1. `backup.sh` takes a directory name as an argument and archives it into a timestamped `file-backup-<date>_<time>.tar.gz` under `backup-data/`.
2. Every step (success or failure) is appended to `backup-data/logfile.log` with a timestamp.
3. On success, the archive is uploaded to the S3 bucket with the AWS CLI, using the instance's IAM role for credentials.
4. A root cron entry runs the script automatically:

```
0 0 * * * root /home/ubuntu/vm-backup-project/sc-backup/backup.sh
```

## Project layout

```
vm-backup-project/
├── backup-data/      # generated .tar.gz archives + logfile.log
├── bash-data/        # sample data being backed up
└── sc-backup/
    └── backup.sh     # the backup script
```

## Usage

```bash
chmod +x sc-backup/backup.sh
./sc-backup/backup.sh <directory-to-back-up>
```

Requirements on the instance:

- AWS CLI installed
- IAM role attached to the EC2 instance with `s3:PutObject` (and `s3:ListBucket` for verification) on the target bucket
- `tar`, `gzip`, `cron`

## Screenshots

| | |
|---|---|
| Project tree | ![project tree](screenshots/project-tree.png) |
| Cron schedule | ![crontab](screenshots/crontab.png) |
| Log file (successful runs) | ![log file](screenshots/log-file.png) |
| S3 bucket contents | ![s3 bucket](screenshots/s3-bucket-contents.png) |
| IAM role | ![iam role](screenshots/iam-role.png) |
| Failure test (missing directory) | ![failure test](screenshots/failure-test.png) |
| Log file after failure test | ![log failure](screenshots/log-file-failure-test.png) |

## Author

Ibrahim — [@ej8m](https://github.com/ej8m)
