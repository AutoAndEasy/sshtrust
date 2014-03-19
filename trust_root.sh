#!/usr/bin/expect
set timeout 30
set host [lindex $argv 0]
set passwd [lindex $argv 1]
set sshport [lindex $argv 2]
set id_rsa "authorized_keys"

set fileId [open $id_rsa r 0400]
set contents [read $fileId]
close $fileId

spawn -noecho /usr/bin/ssh -p$sshport "root@$host" -oStrictHostKeyChecking=no
expect "*password:*" {send "$passwd\r"}
expect "*password:*" {send "YourPassword2\r"}
expect "*password:*" {send "YourPassword3\r"}
set timeout 2

expect "]# " {send "cd /root/ || exit 1\n"}
expect "]# " {send "cd /root/ ;if \[ \! \-d .ssh \];then mkdir .ssh;fi ; chmod 700 .ssh ; cd .ssh\n"}
expect "]# " {send "echo \"$contents\" >> authorized_keys\n"}
expect "]# " {send "chmod 600 authorized_keys\n"}
expect "]# " {send "cd ..;chown -R root.root .ssh\n"}
expect "]# " {send "exit\n"}

expect eof
exit 0
