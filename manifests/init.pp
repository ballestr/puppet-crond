## light wrapper to define a cronjob in /etc/cron.d
## Arguments :
## - mail defaults to "root"; set it to "" if you _really_ want it not to send mail (discouraged)
## - jobs is the job definition in /etc/crontab format. It can be an array of lines. 
## example usage :
##  $t=fqdn_rand(10)+24 # randomised start time
##    crond::job {
##        "kipmicheck":
##        comment => "Check kipmi CPU usage, reset mc",
##        mail => "atlas-tdaq-sysadmins-logs@cern.ch",
##        jobs => "$t * * * * root /var/sbin/check_kipmi.sh",
##    }
##
define crond::job($jobs,$comment,$mail="root") {
    ## sanity check to avoid UNSAFE failures
    if ($mail =~ / /) {
        fail("crond::job $name : UNSAFE, bad characters [ ] in mail=>'$mail'")
    }
    $callername=$caller_module_name?{""=>"called from node, no module",default=>"called from module $caller_module_name"}
    file {
        "/etc/cron.d/${name}_puppetcron":
        owner=>root,group=>root,
        content=>template("crond/job.erb"),
    }
}
