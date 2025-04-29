# Linux Backup Script

## Description
A Linux backup script with options for mirrored and incremental backups and remote bidirectional ssh support.  

## Requirements
- **Operating System**: Linux.  
- **File System**: ext4, btrfs.  

---

## Features
- Remote ssh backup support.
- Detailed logs in the destination directory.  
- Easy replication of backups to multiple disk drives or server location.
- Crontab scheduling capability.
- Fast incremental backups.
- configuration file separate from the main script.

---

## Installation

1. Clone the repository.  

2. It's recommended to encrypt the destination drive with LUKS and set a secret password, noting it down in your password manager or on paper.  

3. Set run permission to the 'install.sh', 'remove.sh', and 'ssh_auto_config.sh' scripts

4. Double-click on 'install.sh' to install app 

5. Open 'ssh_auto_config.sh' and set 'SSH_USER_SERVER' to your username@servername

6. Double-click on 'ssh_auto_config.sh' for auto config and send ssh public key to the server

7. Set the source and destination directories for backups in the configuration files (`backup.conf`), which will be created automatically.  

8. The first backup will be full (time-consuming), but subsequent backups will copy only modified files since the last backup, making them much faster.

---

## Configuration

### Make Backup
- **BACKUP_TYPE**: Backup type selection 
- **DAY_LIMIT**: backup history changes (valid for rsync)  
- **FROM_PATH**: Source directory path for backup  
- **TO_PATH**: Destination directory path  

Example (`backup.conf`):  
```bash

BACKUP_TYPE=1 # Rsync Mirror Backup (with ssh support)
#BACKUP_TYPE=2 # Rsync Incremental Backup
#BACKUP_TYPE=3 # Tar Incremental Backup

DAY_LIMIT=7 # backup history changes (7 days)

FROM_PATH+=("/home/$USER/.config/gqrx")
FROM_PATH+=("/media/$USER/KINGSTON_1TB/Docs/Links")
FROM_PATH+=("/media/$USER/KINGSTON_1TB/Installed/EAGLE-6.3.0")
FROM_PATH+=("/media/$USER/KINGSTON_1TB/Docs/Develop/Projects/My_GitHub")
FROM_PATH+=("/media/$USER/KINGSTON_1TB/Docs/KeePassXC")

# Disk Unit 1
TO_PATH+=("/media/$USER/FlashDisk1/IncBackup")

# Disk Unit 2 (Replicated content to remote server)
TO_PATH+=("user@remote-server:/media/$USER/SSD_2TB/Backups")

```

---

## Usage

```bash

# For backup directories:
# Type 'backup' in the terminal window in the same directory where the backup.conf file is located 
backup 

# For restore directories:
# Type 'restore' in the terminal window in the same directory where the backup.conf file is located
restore 

```

---

## Limitations
- Does not copy files directly, only folders containing the files.
- No built-in assistant for restoring incremental rsync backups.  
- Invalid file names may cause backup errors.  
- Backups cannot be made from Linux system files to a Windows partition (NTFS, EXFAT, FAT32, or FAT). Use Linux file systems like ext4 or btrfs instead. However, NTFS can still be used for common file copies with mirror backups.  
- The tar incremental backup does not remove files that might have been deleted from the source.  

---

## Author

- **Junon M.**  
  Contact: [junon10@tutamail.com](mailto:junon10@tutamail.com)

## Changelog

| Version | Date        | Changes Made               |
|---------|-------------|---------------------------|
| 1.0.0.9 | 2025/01/05 | Simplification of parameters. Added function to keep only the most recent backups. Code reorganization. |
| 1.0.0.10 | 2025/01/08 | Improved terminal messages and formatting. |
| 1.0.0.11 | 2025/01/08 | Enhanced message formatting. |
| 1.0.0.12 | 2025/01/13 | Improved logs and messages. New incremental and restore scripts with tar command. |
| 1.0.0.13 | 2025/01/13 | Fixed script (make_rsysnc_inc_backup.sh) to use relative links instead of absolute links. |
| 1.0.0.14 | 2025/01/14 | Automatic directory creation. |
| 1.0.0.15 | 2025/01/16 | Removed excessive log messages for standard logs. |
| 1.0.0.16 | 2025/01/24 | Improved some messages. |
| 1.0.0.17 | 2025/01/27 | Changed scripts to enable automatic backups scheduled on Linux (Crontab). |
| 1.0.0.18 | 2025/03/19 | Improved terminal messages |
| 1.0.0.19 | 2025/04/22 | Improved terminal messages |
| 1.0.0.21 | 2025/04/29 | ssh support for rsync mirror backups |
| 1.0.0.22 | 2025/04/29 | add installer app |
| 1.0.0.23 | 2025/04/29 | add protection rules |
---

## License

- GPLv3

---

## Repository

[https://github.com/junon10/linux-backup-script](https://github.com/junon10/linux-backup-script)

## Contributions

Contributions are welcome! Feel free to fork the repository and submit pull requests with your improvements.  
