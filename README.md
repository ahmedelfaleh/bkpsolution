# Backup Service.
### The Internal Backup Policy - Implementation
#### A. The Main Concept Of Our Backup Policy
Rsnapshot service is the main player in thi backup script, where Rsnabshot controls everything from dumping mysql to backing up all accounts and all run from within Rsnapshot.

#### B. The Benefits
1. Prevent starting mysqldump & os backup at the same time, or starting data backup while os backup is not finished yet.
2. Now all backup procedures run in sequence, preventing interfering or long wait times between backup cron jobs.
3. Backup starts and ends in the lowest time possible.
4. Easier calculation of the space used by backup with one single command “rsnapshot du”.
5. Making audits easier.
6. Clean and unified backup directories under /backup, you will find everything you need under daily.0, daily.1, daily.2, weekly.0, weekly.1 and monthly.0.

For example:
You will find inside /backup directory on the server mysqldump backup, os backup & home backup - all backup inside one directory.
Best backup retention, at any time the client asks for a backup version from the previous week or month he will find it.
7. The New MySQL Dump script (dbbackup) Benefits:
    *  Secure databases dump with 0600 permissions.
    *  Detailed Log file under /var/log/dbbackup for easier audit of the failed backups.
    *  Smaller mysql dump files.
    *  Faster backup and restore.
    *  Even the cron jobs that runs the backup got an update here is it:
    	- 00 01 1 * * root rsnapshot monthly || /elfalehtools/report
    	- 30 01 */7 * * root rsnapshot weekly || /elfalehtools/report
    	- 00 2 * * * root rsnapshot daily || /elfalehtools/report

#### C. How It Works, And What Its Intervals
Daily backup runs every day at 2 AM. weekly backup runs every 7 days
at 1:30 AM so it is now more accurate and predictable than running it
every Sunday for example, now it will run on 1st, 8th ,15th ,22nd and 29th
day of every month. monthly backup runs every 1st day of every month
taking the weekly backup weekly.1 which runs on the 22nd day of the
month which takes the oldest daily backup at that time which will be
19th day of every month so at any day of the current month we will have
monthly backup of the 19th day of the previous month.
Another thing, you can notice in the above crons the time in which they
run.

First the highest level backup (monthly) at 1:00 AM then the lowest
(weekly) at 1:30 AM then the lowest (daily) at 2:00 AM.
Page 5 of 8This order is important for fast, correct and predictable backups
because for example if the daily starts first at 1:00 AM it will be hard to
know when it will finish because it makes the actual backup with rsync
even worse if the daily not finish when the monthly begin then
rsnapshot will not make a monthly backup for this month because by
default only one rsnapshot process can run at the same time. Also it will
be slower because it will have to delete the oldest daily backup daily.2
before it starts.
#### D. Implementation Steps
Run these commands as a root user:
`sh install.sh`
You will be required to enter you email, please enter a valid one, and leave the script to complete it's process.