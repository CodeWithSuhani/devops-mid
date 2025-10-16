#!/bin/bash

function setup_projects() {

dir="/home/$1/"

# $1 = username and $2 = no. of projects
for (( i=1; i <= "$2" ; i++ )) do
	f="PROJECT$i"
	mkdir "$dir$f"
	chmod 755 "$dir$f"
	fc="${dir}${f}/README.txt"
	touch "$fc"
	chmod 640 "$fc"
	echo "Creation date is $(date)" >> "$fc"
	echo "Username is $1" >> "$fc"
	if [[ "$?" == 0 ]]; then
		echo "Sucessfully created  $f and added README.txt file."
	else
		echo "Task Unsuccesfull"
		echo "$?" 
	fi
	done 
}

function sys_report() {
echo "Disk Usage added" > "$1"
df -h >> "$1"
echo "Memory Usage added" >> "$1"
free -h >> "$1"
echo "CPU Info added" >> "$1"
lscpu >> "$1"
echo "Top 5 memory consuming processes" >> "$1"
top -o %MEM | head -n 5+7  >> "$1"
echo "Top 5 cpu consuming processes" >> "$1"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 5 >> "$1"
 if [[ "$?" == 0 ]]; then
                echo "Sucessfully added disk usage, memory usage, cpu usage, cpu consuming and memory consuming processes"
        else
                echo "Task Unsuccesfull"
        fi
        echo "$?"
}


function process_manage() {
case "$2" in 
	"list_zombies")
		echo "Printing zombie processes..."
		ps aux | grep 'Z'
		;;
	"list_stopped")
		echo "Listing stopped processes..."
		ps aux | awk '$8=="T"'
		;;
	"kill_zombies")
		echo "Killing zombie process.."
		echo "Exit Status:1"
		echo "Cannot kill directly"
		;;
	"kill_stopped")
		echo "Killing stopped processes.."
		kill -9 'jobs -ps'
esac
 if [[ "$?" == 0 ]]; then
                echo "$2 successful for $1."
        else
                echo "Task Unsuccesfull"
		echo "$?"
        fi
}

function perm_owner() {
un="$1"
pa="$2"
p="$3"
own="$4"
grp="$5"
echo "Changing permisions recursively.."
chmod -R "$p" "$pa"
 if [[ "$?" == 0 ]]; then
                echo "Sucessfully changed permissions."
        else
                echo "Task Unsuccesful"
		echo "$?"
	fi
echo "Changing ownership recursively.."
chown -R "$own":"$grp" "$pa"
 if [[ "$?" == 0 ]]; then
                echo "Sucessfully changed ownership."
        else
                echo "Task Unsuccesfull"
		echo "$?"
        fi 
}
function help() {
echo "Example Commands"
echo "./sys_manager.sh add_users users.txt- currently unavailable"
echo "./sys_manager.sh setup_projects alice 5"
echo "./sys_manager.sh sys_report sysinfo.txt"
echo "./sys_manager.sh process_manage bob list_zombies"
echo "./sys_manager.sh perm_owner alice /home/alice/projects 755 alice alice"
echo "./sys_manager.sh help"
echo "These may help to execute your tasks"
echo "Please avoid adding false usernames and non existing files and directories"
echo "thankyou"
}
