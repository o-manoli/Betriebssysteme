#!/bin/bash

#####################################
#
# Author: @O-Manoli
#
# WS23-24
#
#####################################

function show_help() {
	echo ""
	echo "Usage: email_analysis.sh [-h| -help] [-r| -email] [-u| -company]"
	echo ""
	echo "	-h| -help:      Zeigt die Hilfe Seite"
	echo "	-e| -email:     Gibt die Anzahl der Mails von dieser Email-Adresse aus"
	echo "	-c| -company:   Gibt die Anzahl und die Firma des Absender aus "
	echo ""
}

EmailPattern="From: [A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"

function show_email {
	cat $1 \
	| grep -E "$EmailPattern" \
	| cut -d ' ' -f 2 \
	| sort | uniq -c \
	| sort -n
}

function show_company {
	cat $1 \
	| grep -E "$EmailPattern" \
	| cut -d ' ' -f 2 \
	| cut -d '@' -f 2 \
	| sort | uniq -c \
	| sort -n
}

CMD="show_email"

POSITIONAL_ARGS=("gcc_2023.08.txt")  # default argument

while [[ $# -gt 0 ]]; do
case $1 in
	-h|--help)
		CMD="show_help"
		shift # past argument
	;;
	-e|--email)
		CMD="show_email"
		shift # past argument
	;;
	-c|--company)
		CMD="show_company"
		shift # past argument
	;;
	*)
		POSITIONAL_ARGS+=("$1") # save positional arg
		shift # past argument
		;;
esac
done

$CMD "${POSITIONAL_ARGS[-1]}"   # last element in the array

