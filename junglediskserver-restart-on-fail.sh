#!/bin/sh

#
# Jungle Disk Server client for Linux has a bug if the Jungle Disk gateway server 
# is restarted then the client enters a stuck state where the client never reconnects 
# and no backups are run. And there is no warning or error reporting to warn you.
#
# This script is a workaround the checks the age of the backup log file. If it
# has not been updated in X hours they we assume the schedule backups did not run
# and we restart the client.
#
# Unfortunately the command line options were removed from Jungle Disk Server 3.x
# so there is no way to start the missed backups other than the management GUI. 
# So I recommend you configure your schedule to run missed backups automatically.
#
# This script is designed to be used in the cron job, and only outputs to stdout/stderr
# if the client needs to be restarted or if the log file is missing.
#
# Aaron Roydhouse <aaron@roydhouse.com>
# Sep 2014
#

# Configure for your environment
#
LOG_FILE=/var/cache/jungledisk/server-cache/logs/backuplog.csv
MAX_AGE_MINS=720
INIT_SCRIPT=/etc/init.d/junglediskserver

# Check for log file
#
if [ ! -r $LOG_FILE ]
then
  echo "Unable to read Jungle Disk Server log file: $LOG_FILE"
fi

# If the log file is older than expected, restart the client
#
if test `find $LOG_FILE -mmin +$MAX_AGE_MINS`
then
  echo "Jungle Disk Server appears stuck, restarting"
  echo "At `date` `basename $LOG_FILE` is more than $MAX_AGE_MINS minutes old"
  $INIT_SCRIPT restart
fi

# end
