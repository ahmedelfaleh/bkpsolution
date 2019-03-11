#!/bin/bash
cd /etc/cron.d/
if [ ! -f backup ]
then
echo "00 01 1 * * root rsnapshot monthly || /orkitools/report
30 01 */7 * * root rsnapshot weekly || /orkitools/report
00 02 * * * root rsnapshot daily || /orkitools/report" | tee --append backup
else
rm -f /etc/cron.d/backup
echo "00 01 1 * * root rsnapshot monthly || /orkitools/report
30 01 */7 * * root rsnapshot weekly || /orkitools/report
00 02 * * * root rsnapshot daily || /orkitools/report" | tee --append backup
fi
