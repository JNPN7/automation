#! /usr/bin/bash

virtualEnvPath="${HOME}/.pyenv/"
installedPythonPath="/usr/bin/python"

## functions ##
function banner(){
echo "
    ____  __  __    _____  ___
   / __ \/ / / /\  / / __''__ \\
  / /_/ / /_/ /\ \/ / / / / / /
 / .___/\__, /  \__/_/ /_/ /_/
/_/    /____/
"
}
function helpFunc(){
echo "Description:
Python virtual envirionment manager

Usage:
	python_env_controller.sh [OPTION]...
Options:
	-h	display help
	-p	display versions of python available in system
	-s	shows all virtual environment	
	-c	create virtual environment
	-v	select virtual envirionment python version
	-a	activate virtual environment
	-d	deactivate virtual environment
	-r	remove virtual environment
Work required:
	-a -d: activate and deactivate not working properly need some work"
}
deactivate () {
    unset -f pydoc >/dev/null 2>&1 || true

    # reset old environment variables
    # ! [ -z ${VAR+_} ] returns true if VAR is declared at all
    if ! [ -z "${_OLD_VIRTUAL_PATH:+_}" ] ; then
        PATH="$_OLD_VIRTUAL_PATH"
        export PATH
        unset _OLD_VIRTUAL_PATH
    fi
    if ! [ -z "${_OLD_VIRTUAL_PYTHONHOME+_}" ] ; then
        PYTHONHOME="$_OLD_VIRTUAL_PYTHONHOME"
        export PYTHONHOME
        unset _OLD_VIRTUAL_PYTHONHOME
    fi

    # The hash command must be called to get it to forget past
    # commands. Without forgetting past commands the $PATH changes
    # we made may not be respected
    hash -r 2>/dev/null

    if ! [ -z "${_OLD_VIRTUAL_PS1+_}" ] ; then
        PS1="$_OLD_VIRTUAL_PS1"
        export PS1
        unset _OLD_VIRTUAL_PS1
    fi

    unset VIRTUAL_ENV
    if [ ! "${1-}" = "nondestructive" ] ; then
    # Self destruct!
        unset -f deactivate
    fi
}

function activate(){
	if [ "${BASH_SOURCE-}" = "$0" ]; then
	    echo "You must source this script: \$ source $0" >&2
	    exit 33
	fi

	# unset irrelevant variables
	deactivate nondestructive

	VIRTUAL_ENV='$virtualEnvPath$activateEnv'
	if ([ "$OSTYPE" = "cygwin" ] || [ "$OSTYPE" = "msys" ]) && $(command -v cygpath &> /dev/null) ; then
	    VIRTUAL_ENV=$(cygpath -u "$VIRTUAL_ENV")
	fi
	export VIRTUAL_ENV

	_OLD_VIRTUAL_PATH="$PATH"
	PATH="$VIRTUAL_ENV/bin:$PATH"
	export PATH

	# unset PYTHONHOME if set
	if ! [ -z "${PYTHONHOME+_}" ] ; then
	    _OLD_VIRTUAL_PYTHONHOME="$PYTHONHOME"
	    unset PYTHONHOME
	fi

	if [ -z "${VIRTUAL_ENV_DISABLE_PROMPT-}" ] ; then
	    _OLD_VIRTUAL_PS1="${PS1-}"
	    if [ "x" != x ] ; then
		PS1="${PS1-}"
	    else
		PS1="(`basename \"$VIRTUAL_ENV\"`) ${PS1-}"
	    fi
	    export PS1
	fi

	# Make sure to unalias pydoc if it's already there
	alias pydoc 2>/dev/null >/dev/null && unalias pydoc || true

	pydoc () {
	    python -m pydoc "$@"
	}

	# The hash command must be called to get it to forget past
	# commands. Without forgetting past commands the $PATH changes
	# we made may not be respected
	hash -r 2>/dev/null
}

function getPythonVersionInstalled(){
	echo "Python version installed in your system:"
	ls /usr/bin/python* | awk -Fon '/n?\./ {print $2}' | awk -F- '{print $1}' | uniq
}

function showAllVirtualEnv(){
	echo "Python virtual environments:"
	ls $virtualEnvPath
}

function checkIfVirtualEnvAlreadyExisted(){
	envs=$(ls $virtualEnvPath)
	envs=( $envs )
	for (( i=0; i<${#envs[@]}; i++)); do
		if [[ $envName == ${envs[$i]} ]]; then 
			echo "Virtual Environment already exists"
			echo "Choose another name"
			echo "Get all existed virtual envs: python_env_controller.sh -s"
			exit 1
		fi
	done
}

function activateEnvironment(){
	envs=$(ls $virtualEnvPath)
	envs=( $envs )
	a=0
	for (( i=0; i<${#envs[@]}; i++ )); do
		if [[ $activateEnv == ${envs[$i]} ]]; then 
			a=1
			break
		fi
	done
	if [[ a -eq 0 ]]; then 
		echo "Virtual Environment doesn't exist"
		echo "Get all existed virtual envs: python_env_controller.sh -s"
		exit 1
	fi
	echo $activateEnv
	path="$virtualEnvPath$activateEnv/bin/activate"
	echo $path
	source $path
	echo "Vitual Environment Activated: $activateEnv"
}
function deactivateEnvirionment(){
	deactivate
	exit 1
}
function createPythonEnvironment(){
	checkIfVirtualEnvAlreadyExisted
	if [[ -n $pythonVersion ]]; then 
		echo "Checking whether you have python version..." 
		python=$(ls /usr/bin/python* | awk -Fon '/n?\./ {print $2}' | awk -F- '{print $1}' | uniq)
		python=( $python )
		a=0
		for (( i=0; i<${#python[@]}; i++ )); do
			if [[ $pythonVersion == ${python[$i]} ]]; then
				a=1
				break
			fi
		done
		if [[ a -eq 0 ]]; then 
			echo "Python version not found in system"
			echo "Check available versions: python_env_controller.sh -p"
			exit 1
		fi
	fi
	echo "Creating python virtual envtionment [$envName $pythonVersion]..."
	envPath="$virtualEnvPath$envName"
	if [[ -n $pythonVersion ]]; then
		path="$installedPythonPath$pythonVersion"
		virtualenv --python=$path $envPath 
	else
		virtualenv $envPath
	fi
	exit 1
}
function removeEnvironment(){
	envs=$(ls $virtualEnvPath)
	envs=( $envs )
	b=0
	for (( i=0; i<${#envs[@]}; i++ )); do
		if [[ $envName == ${envs[$i]} ]]; then 
			b=1
			break
		fi
	done
	if [[ b -eq 0 ]]; then 
		echo "Virtual Environment doesn't exist"
		echo "Get all existed virtual envs: python_env_controller.sh -s"
		exit 1
	fi
	read -p "Do you really want to remove $envName [Y,n]:" remove
	if [[ $remove == 'y' || $remove == 'Y' ]]; then
		rm -r $virtualEnvPath$envName
		echo "$envName deleted"
		exit 1
	fi
	echo "Aborting..."
	exit 1
}

## flags ##
while getopts dsphc:v:a:r: flag; do
	case $flag in
		h)
			helpFunc
			exit 1
			;;
		p)
			getPythonVersionInstalled
			exit 1
			;;
		s)
			showAllVirtualEnv
			exit 1
			;;
		c)
			createEnv=1
			envName=${OPTARG}
			if [[ ${envName:0:1} == '-' ]]; then
				echo "Invalid argument"
				echo "Must supply an argument to -c"
			fi
		       	;;
		v)
			pythonVersion=${OPTARG}
			if [[ ${pythonVersion:0:1} == '-' ]]; then
				echo "Invalid argument"
				echo "Must supply an argument to -v"
			fi
			;;		
		a)
			activate=1
			activateEnv=${OPTARG}
			if [[ ${activateEnv:0:1} == '-' ]]; then
				echo "Invalid argument"
				echo "Must supply an argument ro -a"
			fi
			;;
		d)
			deactivate
			exit 1
			;;
		r)
			remove=1
			envName=${OPTARG}
			if [[ ${envName:0:1} == '-' ]]; then
				echo "Invalid argument"
				echo "Must supply an argument to -r"
			fi
			;;
		:)
			echo "Must supply an argumnet to -$OPTARG"
			exit 1
			;;
		*)
			echo "Invalid options"
			echo "Get help:"
			echo "python_env_controller.sh -h"
			exit 1
			;;
	esac
done

if [[ -n $createEnv ]]; then
	createPythonEnvironment
elif [[ -n $activate ]]; then 
	activateEnvironment
	#echo "~/.pyenv/test/bin/activate"
elif [[ -n $remove ]]; then
	removeEnvironment
fi

## banner ##
banner
echo "Description:
Python virtual envirionment manager

Get help:
python_env_controller.sh -h"
