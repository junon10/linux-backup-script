<h2>Linux Backup Script</h2>
<h3>Operational System:</h3> Linux
<h3>File System:</h3> Linux and Windows
<h3>Author:</h3> Junon M
<h3>Version:</h3> 1.0.0.9
<h3>Date:</h3> 2025/01/05

<h3>Description:</h3> 
<p>The Mirroring script runs on any file system, however, the Incremental backup script only works on Linux file systems, such as ext4. After the first copy only the differences are added with the two script variations, ensuring a high backup speed. Both script variations generate very detailed logs on the target drive.</p>
<h3>NOTES:</h3>
<p>Only mirror backup has an automatic restore script that recreates all folders after formatting. In incremental backup, folders must be restored manually with the desired date and time.</p>
<p>These Scripts have been tested for a long time, sometimes restoration was necessary and there was no loss of files.</p>
<p>Be careful with invalid file names, they make the backup fail!</p>

<hr>

# 2025/01/05 - 1.0.0.9 
# Changes:
<p>1 - Keep only the most recent backups (N days).</p>
<p>2 - Simplification of configuration parameters.</p>
<p>3 - Improvements in data presentation.</p>

<hr>

<h3>Mirror Backup Example file:</h3> 
<h3>backup_path.txt</h3> 
<br/>
# Example:
<br/><br/>
FROM_PATH+=("/home/$USER/Backup_Test/From/Folder1")
<br/>
FROM_PATH+=("/home/$USER/Backup_Test/From/Folder2")
<br/><br/>
TO_PATH+=("/home/$USER/Backup_Test/To/Mirror_Backup1")
<br/>
TO_PATH+=("/home/$USER/Backup_Test/To/Mirror_Backup2")
<br/><br/>

<hr>

<h3> Incremental Backup Example File: </h3> 
<h3>inc_backup_path.txt</h3>
<br/><br/>
FROM_PATH+=("/home/$USER/Backup_Test/From/Folder1")
<br/>
FROM_PATH+=("/home/$USER/Backup_Test/From/Folder2")
<br/><br/>
TO_PATH+=("/home/$USER/Backup_Test/To/Incremental_Backup1")
<br/>
TO_PATH+=("/home/$USER/Backup_Test/To/Incremental_Backup2")
<br/><br/>
DAY_LIMIT=7 # Keep only the most recent backups (7 days)
<br/><br/>

<hr>


