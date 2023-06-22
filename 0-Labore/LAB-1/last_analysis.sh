#!/bin/bash

# just in case you creates temporary files.
# In this script I used an array and mapfile
init (){ # otherwise init must be called!

	tmp_dir=$(mktemp -d)

	# by default the directory is created under `/tmp/` with a random name

	export tmp_dir	# make it a global var

	cd $tmp_dir		# when run like `bash <script>` `cd` not the effect the parent process

}

cleanup (){

	if test $tmp_dir; then

		# shouldn't remove `$PWD`
		cd ..

		rm -rf $tmp_dir

	fi

}

trap cleanup EXIT

function show_help() {
	echo "Usage: last_analysis.sh [-h|--help] [-r|--runtime] [-u|--user]"
	echo ""
	echo "Shows users logins frequency Lists the uptime with the kernel version."
	echo ""
	echo "	-h|--help: Shows help page and quits"
	echo "	-r|--runtime: Lists uptime with the kernel version"
	echo "	-u|--user: Sorted list of "
	echo ""
}

function show_runtime {

	# capture the output in an array
	declare -a reboots

	mapfile reboots < <(last | grep reboot | grep -v "still running" | awk '{print $4 " " $(NF)}')

	function awk_parser {
		# prints the kernel name
		# the uptime if found otherwise 0 by trying to match the regex `/\(([0-9]+)\+/`
		# at the endS the word `days` with a new line
		echo $@ | awk '{printf $1 " "}
		{match($(NF), /\(([0-9]+)\+/, number); if (number[1]) printf number[1]; else printf 0;}
		{printf " days\n"}'
	}

	last | grep "still running" | awk '{print $4 " " $(NF-1) " " $(NF)}'

	for line in "${reboots[@]}"
	do
		awk_parser $line
	done
}

function show_user {

	# last						-> return logins

	# grep -E '^[^$]'			-> filter out empty lines

	# grep -vE '^reboot|^wtmp'	-> return lines that doesn't match

		# ^[word]	means starting with that `word`
		# grep -v	reverse match
		# grep -E	match regex
		# |			OR operator within the regex

	# cut -d ' ' -f 1			-> return the first `field` from each line

		# cut -d ' '	field delimiter aka separator
		# cut -f 1		return only the first field

	# sort					-> alphabetical sort of usernames # necessary for `uniq -c`

	# uniq -c				-> counts **repeated** line

	# sort 					-> sort the count

	last | grep -E '^[^$]' | grep -vE '^reboot|^wtmp' | cut -d ' ' -f 1 | sort | uniq -c |

}

OPTIONS=hru
LONGOPTD=help,runtime,user

while getopts "$OPTIONS" opt; do
	case "$opt" in
	h|help)
		show_help
		exit
		;;
	r|runtime)
		show_runtime
		exit
		;;
	u|user)
		show_user
		exit
		;;
	esac
done


# no exit statement was triggered
# no args || wrong ones
show_runtime


