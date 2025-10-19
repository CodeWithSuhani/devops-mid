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
help 
}

function sys_report() {
echo "Disk Usage added" > "$1"
df -h >> "$1"
echo "Memory Usage added" >> "$1"
free -h >> "$1"
echo "CPU Info added" >> "$1"
lscpu >> "$1"
echo "Top 5 memory consuming processes" >> "$1"
top -o %MEM | head -n 12  >> "$1"
echo "Top 5 cpu consuming processes" >> "$1"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 5 >> "$1"
 if [[ "$?" == 0 ]]; then
                echo "Sucessfully added disk usage, memory usage, cpu usage, cpu consuming and memory consuming processes"
        else
                echo "Task Unsuccesfull"
        fi
        echo "$?"
help
}
#sys_report system_reports.txt

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
help
}
#process_manage suhani list_stopped
#process_manage suhani list_zombies
#process_manage suhani kill_stopped
#process_manage suhani kill_zombies

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
help 
}
#perm_owner suhani /dir1 755 suhani suhani

function help() {
echo "HELP MENU"
echo " 1 : add_users."
echo " 2 : setup projects."
echo " 3 : system reports."
echo " 4 : process manager."
echo " 5 : changing permission and ownership."
echo " 6 : to exit dropdown menu."
read -p "Enter your choice" ch
case "$ch" in
	1)
		add_users
		;;
	2)
		read -p "Enter username: " un
                read -p "Enter the number of projects: " n
		setup_projects "$un" "$n"
		;;
	3)
		sys_report system_reports.txt
		;;
	4)
		read -p "Enter username: " un
		echo "Enter list_stopped to list stopped processes."
		echo "Enter list_zombies to list zombie processes."
		echo "Enter kill_stopped to kill stopped processes."
		echo "Enter kill_zombies to kill zombie processes. "
		read c
		process_manager "$un" "$c"
		;;
	5)
		read -p "Enter username : " un
		read -p "Enter path to directorymor file : " di
		read -p "Enter desired permisions : " pe
		read -p "Enter owner name : " o
		read -p "Enter group name : " g 
		perm_owner "$un" "$di" "$pe" "$o" "$g"
		;;
	6)
		echo "Redirecting to welcome message."
		y
		;;
esac
}
function y() {
echo "Welcom to User \& System Management Automation program.."  
read -p "Enter 'y' to see the dropdown  menu or  'n' to exit user & System management Automation program." ok
case "$ok" in
	"y")
		help
		;;
	"n")
		echo "Thanks for visiting!"
		exit 0
		;;
	*)
		echo "Wrong choice"
		y
		;;
esac
}
y
