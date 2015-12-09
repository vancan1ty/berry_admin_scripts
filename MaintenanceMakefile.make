#Currell Berry this makefile is used to automate various maintenance procedures on my system
#example: make -sf MaintenanceMakefile.make getAbusers

getAbusers:
	grep root /var/log/authlog | grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' | sort | uniq -c | sort -n | awk '$$1 > 10 {print $$0}'

reloadPfRules:
	pfctl -d
	pfctl -e -f /etc/pf.conf

showBlockedIps:
	pfctl -t abusers -T show

#Bash/Ksh snippets section

#heredocs
#$ tr a-z A-Z << EOF
#> one two three
#> four five six
#> EOF
#

#loops
#for f in `ls`; do echo $f | tr a-z A-Z; done
#for s in once upon a time; do echo 'Simon Said '$s; done
#i=0; while test $i -lt 1000; do echo $i; (( i += 1 )); done

#  OPENBSD:
#  for i in `jot 11 0 1000`; do echo hello$i; done
#  LINUX:
#  for i in `seq 0 100 1000`; do echo hello$i; done

#conditionals
#if test 1 -eq 2 -o 1 -gt 3; then echo 'hi'; else echo 'bye'; fi
#if test -e myfile.txt; then echo 'file exists'; fi
#

#equality tests you can pass to test:
#there are a variety of unary file existence tests.  
#-e file : true if file exists
#-f file : true if file exists and is a regular file
#-d file : true if the file exists and is a directory
#-r #readable, -w #writable, -z #zero length
#
# binary file tests
#f1 -nt f2 #f1 newer than f2?
#f1 -ot f2 #f1 older than f2?
#f1 -ef f2 #f1 same file as f2?
#
# string tests
#s1 = s2, s1 != s2, s1 < s2, s1 > s2, s1 #last one is null check 
#
# number tests
#n1 -e1 -n2, -ne, -gt, -ge, -lt, -le
#
# combine with
#!, -a (AND), -o (OR), ( expression ) (PRECEDENCE)
#or just do test 1 -e1 1 && \( test 2 -eq 2 \)

#USEFUL MAINTENANCE TASKS
#to disable remote password login on a server, make the follwign changes 
#to the sshd_config file (/etc/ssh/sshd_config).
#   ChallengeResponseAuthentication no
#   PasswordAuthentication no
#   UsePAM no
