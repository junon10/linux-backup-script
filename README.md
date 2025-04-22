# Linux Backup Script

## Description
A Linux backup script with options for mirrored (sync) and incremental backups.  

## Requirements
- **Operating System**: Linux.  
- **File System**: ext4, btrfs.  

---

## Features
- Detailed logs in the destination directory.  
- Easy replication of backups to multiple disk drives.
- Crontab scheduling capability.
- Fast incremental backups.
- configuration file separate from the main script.

---

## Installation

1. Clone the repository.  

2. It's recommended to encrypt the destination drive with LUKS and set a secret password, noting it down in your password manager or on paper.  

3. Choose which set of scripts you want to use (items 4, 5, or 6), as using them together may cause increased disk space usage.  

4. For **mirror backups**, copy (`make_rsync_backup.sh`, `restore_rsync_backup.sh`, `backup_path.txt`, and `Sounds` folder), to the destination drive.  

5. For **incremental backups with rsync**, copy (`make_rsync_inc_backup.sh`, `inc_backup_path.txt`, and `Sounds` folder) to the destination drive.  

6. For **incremental backups with tar**, copy (`make_tar_inc_backup.sh`, `restore_tar_inc_backup.sh`, `inc_backup_path.txt`, and `Sounds` folder) to the destination drive.  

7. Configure the source and destination directories for backups in the configuration files (`backup_path.txt` or `inc_backup_path.txt`), which will be created automatically.  

The first backup will be full (time-consuming), but subsequent backups will copy only modified files since the last backup, making them much faster.

---

## Configuration

### Mirror Backup
- **FROM_PATH**: Source directory path for backup  
- **TO_PATH**: Destination directory path  

Example (`backup_path.txt`):  
```bash

#-------------------------------------------------------------------------------
# Mirror Backup
#-------------------------------------------------------------------------------

FROM_PATH+=("/home/$USER/.config/gqrx")
FROM_PATH+=("/media/$USER/KINGSTON_1TB/Docs/Links")
FROM_PATH+=("/media/$USER/KINGSTON_1TB/Installed/EAGLE-6.3.0")
FROM_PATH+=("/media/$USER/KINGSTON_1TB/Docs/Develop/Projects/My_GitHub")
FROM_PATH+=("/media/$USER/KINGSTON_1TB/Docs/KeePassXC")

# Disk Unit 1
TO_PATH+=("/media/$USER/FlashDisk1/SyncBackup")

# Disk Unit 2 (Replicated content)
TO_PATH+=("/media/$USER/FlashDisk2/SyncBackup")

```

### Incremental Backup
- **FROM_PATH**: Source directory path for backup  
- **TO_PATH**: Destination directory path  
- **DAY_LIMIT**: Number of days to keep backups (valid for rsync)  

Example (`inc_backup_path.txt`):  
```bash

#-------------------------------------------------------------------------------
# Incremental Backup
#-------------------------------------------------------------------------------

FROM_PATH+=("/home/$USER/.config/gqrx")
FROM_PATH+=("/media/$USER/KINGSTON_1TB/Docs/Links")
FROM_PATH+=("/media/$USER/KINGSTON_1TB/Installed/EAGLE-6.3.0")
FROM_PATH+=("/media/$USER/KINGSTON_1TB/Docs/Develop/Projects/My_GitHub")
FROM_PATH+=("/media/$USER/KINGSTON_1TB/Docs/KeePassXC")

# Disk Unit 1
TO_PATH+=("/media/$USER/FlashDisk1/IncBackup")

# Disk Unit 2 (Replicated content)
TO_PATH+=("/media/$USER/FlashDisk2/IncBackup")

DAY_LIMIT=30 # Backup History = 30 days

```

---

## Usage

```bash
# Perform incremental backup with rsync  
./make_rsync_inc_backup.sh  

# Perform mirrored backup with rsync  
./make_rsync_backup.sh  

# Restore mirrored backup with rsync  
./restore_rsync_backup.sh  

# Perform incremental backup with tar  
./make_tar_inc_backup.sh  

# Restore incremental backup with tar  
./restore_tar_inc_backup.sh
```

---

## Limitations
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

---

## License

- GPLv3

---

## Repository

[https://github.com/junon10/linux-backup-script](https://github.com/junon10/linux-backup-script)

## Contributions

Contributions are welcome! Feel free to fork the repository and submit pull requests with your improvements.  
