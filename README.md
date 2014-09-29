junglediskserver-restart-on-fail
================================

Restart Jungle Disk Server for Linux when it get stuck after the gateway at Jungle Disk is restarted

Jungle Disk Server client for Linux has a bug if the Jungle Disk gateway server 
is restarted then the client enters a stuck state where the client never reconnects 
and no backups are run. And there is no warning or error reporting to warn you.

This script is a workaround the checks the age of the backup log file. If it
has not been updated in X hours they we assume the schedule backups did not run
and we restart the client.

Unfortunately the command line options were removed from Jungle Disk Server 3.x
so there is no way to start the missed backups other than the management GUI. 
So I recommend you configure your schedule to run missed backups automatically.

This script is designed to be used in the cron job, and only outputs to stdout/stderr
if the client needs to be restarted or if the log file is missing.

Aaron Roydhouse  
aaron@roydhouse.com  
Sep 2014

Install
-------

Sample install steps are below. The script requires `test`, `date`, and `basename`. *You must inspect and configure the script yourself after each time you download it from this website before you use it.*

```
cd /etc/jungledisk
wget https://raw.githubusercontent.com/whereisaaron/junglediskserver-restart-on-fail/master/junglediskserver-restart-on-fail.sh
chmod 0700 junglediskserver-restart-on-fail.sh
cronttab -e
```

Here is a sample cron entry to run daily at 6am. The test will still fail until the next back-up is run, so you probably should no run it more often then daily.
```
* 6 * * * /etc/jungledisk/junglediskserver-restart-on-fail.sh  #Restart Jungle Disk Server when stuck
```
