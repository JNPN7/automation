#! /usr/bin/bash

echo $5
## Set variables ##
loc=$5
dirs=("controllers" "views" "public" "models" "routes" "middleware")
indexFile="index.js"
configFile="config.json"
declare -A files=(["routes"]="web.js+api.js") ## add needed files --> (["route"]="web.js+api.js" ["controllers"] ="adminController.js+userController.js") 

## some styles ##
figlet node js -f slant

## functions ##
function helpFunc(){
echo "Description:
Creates node js project

Usage: 
	nodejs.sh [OPTION]... -f PROJECT_NAME

Options:
	-f	project name this option is mandatory
	-p	package name to be installed for multiple package the package should be separated by '+'. 
		Eg: package1+package2
	-h	display this help and exit

"
}

function splitString(){
	local -a arr=()
	string=$1
	IFS='+'     # hyphen (-) is set as delimiter
	read -ra array <<< "$string"   # str is read into an array as tokens separated by IFS

	IFS=' '     # reset to default value after usage
	
	len=${#array[@]}

	for (( i=0; i<$len; i++ )); do 
		arr[i]=${array[i]}
	done
	echo ${arr[@]}
}

function check(){
	if [[ $? -ne 0 ]]; then
		echo Mount required
		exit 1
	fi

	if [[ -z "$projectName" ]]; then
		echo Name must be given to project
		echo "Get help:"
		echo "nodejs.sh -h"
		exit 1
	fi

	if [[ -e "$projectName" ]]; then
		echo Project already exits
		exit 1
	fi
}

function makeDir(){
	for dir in "${dirs[@]}"; do
		mkdir $loc/$projectName/$dir
	done
}

function makeFiles(){
	for dir in "${!files[@]}"; do
		declare -a arr=$(splitString ${files[$dir]})
		for file in ${arr[@]}; do
			touch "$loc/$projectName/$dir/$file"
		done
	done
}

## flags ##
while getopts :f:p:h flag; do
	case $flag in
		h) 
			helpFunc
			exit 1
		;;
		f)
			projectName=${OPTARG}
		;;
		p)
			additionalInstall=${OPTARG}
		;;
		*)
			echo "Invalid options"
			echo "Get help:"
			echo "nodejs.sh -h"
			exit 1
		;;
	esac
done

## main ##
echo "Creating node js project"
cd $loc
echo $loc
check

mkdir $projectName
touch $loc/$projectName/$indexFile
touch $loc/$projectName/$configFile

makeDir

makeFiles

## create assets and style ##
mkdir $loc/$projectName/public/assets
touch $loc/$projectName/public/assets/styles.css

cd $projectName
#### npm initializaition ####
npm init

#### install additional packages ####
if [[ -n "$additionalInstall" ]]; then
	declare -a arr=$(splitString $additionalInstall)
	for package in ${arr[@]}; do
		echo "####### Installing package $package #######"
		npm install $package --save
	done
fi


