#! /usr/bin/bash


max_sen="70%"
min_sen="0%"

on=34
off=35

figlet -f slant "L3Th4L"
echo """ 
wanna cheat on exam?
run this scrip in background
install xinput and alsa-utils

press [ for sensitivity of microphone to be max
press ] for sensitivity of microphone to be min

May the force be with you
"""

amixer sset Capture $max_sen
xinput test-xi2 --root 3 | gawk '/RawKeyRelease/ {getline; getline; print $2; fflush()}' | while read -r key; do 
	if [ $key = $on ]; then
		amixer sset Capture $max_sen
	fi
	if [ $key = $off ]; then
		amixer sset Capture $min_sen
	fi
done

