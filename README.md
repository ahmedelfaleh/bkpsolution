# NewBkpSolution
## Internal Backup Policy – The Implementation

### The Plan
Because we use Rsnabshot on every server I decided to make it the main player where Rsnabshot controls every thing from dumping mysql to backup cpanel accounts all run from within Rsnabshot this have great benefit between them:

Prevent starting of mysqldump & os backup at the same time or cpanel backup starts while os backup not finished yet. now all backup procedures runs in sequence preventing interfering or long wait times between backup cron jobs. Backup starts and ends in the lowest time possible on all servers.

Easier calculation of the space used by backup on all servers cpanel and non cpanel with one single command “rsnapshot du”. making audit also easier.

Clean and unified backup directories under /backup. you will find every thing you need under daily.0 daily.1 daily.2 weekly.0 weekly.1 monthly.0 on all servers cpanel and non cpanel. for example you will find inside each directory on cpanel server the cpanel backup & os backup and on non cpanel you will find mysqldump backup & os backup & home backup all backup inside one directory.

Better backup retention. Any time client asks for a backup version from the previous week or month he will find it. Better than cpanel backup solution.

The new msyql dump script (dbbackup) that I have released the last month got some updates and more tests in production and to summarize it’s benefits over the old mysql dump script

##### Secure databases dump with 0600 permissions.
##### Detailed Log file under /var/log/dbbackup for easier audit the failed backups.
##### Smaller mysql dump files.
##### Faster backup and restore.
##### Even the cron jobs that runs the backup got an update here is it:

###### 00 01 1 * * root rsnapshot monthly || /orkitools/report
###### 30 01 */7 * * root rsnapshot weekly || /orkitools/report
###### 00 2 * * * root rsnapshot daily || /orkitools/report

Daily backup runs every day at 2 AM. weekly backup runs every 7 days at 1:30 AM so it is now more accurate and predictable than running it every Sunday now it will run on 1,8,15,22,29 day of every month. monthly backup runs every 1 day of every month taking the weekly backup weekly.1 which runs on 22 day of the month which takes the oldest daily backup at that time which will be day 19 of every month so at any day of the current month we will have monthly backup of the 19 day of the previous month.

Anthoer thing you can notice in this crons the time in which they run. First the highest level backkup (monthly) on 1 AM then the lowest (weekly) on 1:30 AM then the lowest (daily) on 2:00 AM. this order is important for fast, correct and predictable backups because for example if the daily starts first at 1 am it will be hard to know when it will finish because it makes the actual backup with rsync even worse if the daily not finish when the monthly begin then rsnapshot will not make a monthly backup for this month because by default only one rsnapshot process can run at the same time. also it will be slower because it will have to delete the oldest daily backup daily.2 before it starts. for more information look at the References.

### The Implementation
#### So here is how to implement this new internal backup system:

#### All servers
I deployed all needed scripts & files already in all servers as follows:
– /orkitools/dbbackup: mysql dump script.
– /orkitools/report: report script to report to sysadmins@horizontechs.com when the cronjobs return non zero status code.
– /etc/cron.d/backup: cronjobs file. open it and unhash all cronjobs when you are ready to use this new backup policy.
– rsnapshot.conf.ht: the unified configuration of rsnapshot. rename it to rsnapshot.conf to replace the old rsanpshot.conf file when you are ready to use this new backup policy.
run command “rsnapshot configtest” to make sure that rsnapshot will run without errors.

#### Non CPanel
Open /etc/rsnapshot.conf and unhash the noncpanel lines & hash the cpanel lines at the end of the file.

#### CPanel
Open /etc/rsnapshot.conf and unhash the cpanel lines & hash the non cpanel lines at the end of the file.
From whm home >> Backup >> Backup Configuration. your configuration should be:
– Backup Status: Enable
– Backup Type: Incremental
– Scheduling and Retention:
  check “Backup Daily”
  check all days
  Retention: 1
  check “Strictly enforce retention, regardless of backup success.”
Note: only 1 daily no weekly and no monthly backup. remember Rsnabshot will manage the retention not CPanel.
– Files
  Check “Backup Accounts”
  Backup Suspended Accounts: Disable
  Backup Access Logs: Disable
  Backup Bandwidth Data: Enable
  Use Local DNS: Disable
  Uncheck “Backup System Files”
– Databases
  Backup SQL Databases: Per Account Only
– Configure Backup Directory
  Default Backup Directory: /backup/daily.0/
  Check “Retain backups in the default backup directory.”
Hash cpanel backup cronjob
### References:
CPanel backup configuration
man rsnapshot


