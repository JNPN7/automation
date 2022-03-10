virtualEnvPath="/home/juhel/.pyenv/"
installedPythonPath="/usr/bin/python"
## functions ##
function helpFunc(){
echo "Description
Python virtual envirionment controller

Usage:
	python_env_controller.sh [OPTION]...
Options:
	-h	display help
	-p	display versions of python available in system
	
"
}

function getPythonVersionInstalled(){
	echo "Python version installed in your system"
	ls /usr/bin/python* | awk -Fon '/n?\./ {print $2}' | awk -F- '{print $1}' | uniq
}

function createPythonEnvironment(){
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
}

## flags ##
while getopts phc:v: flag; do
	case $flag in
		h)
			helpFunc
			exit 1
			;;
		p)
			getPythonVersionInstalled
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
			if [[ ${envName:0:1} == '-' ]]; then
				echo "Invalid argument"
				echo "Must supply an argument to -v"
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
fi
