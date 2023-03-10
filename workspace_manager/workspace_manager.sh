#! /usr/bin/bash
workspacePath="${HOME}/.vsworkspace"
projectPath=$(pwd)
workspaceTemplate="${HOME}/Documents/automation/vscode_workspace_manager/workspace_template"

## functions ##
function banner(){
echo "
 _   _____________      _____  ___
| | / / ___/ ___/ | /| / / __''__ \\
| |/ (__  ) /__ | |/ |/ / / / / / /
|___/____/\___/ |__/|__/_/ /_/ /_/
May the force be with you
"
}

function helpFunc() {
echo "Description:
Vscode workspace manager

Usages:
	workspace_manager.sh [OPTION]...
Options:
	-h	display help
	-s	show all workspace
	-c	create workspace
	-r	remove workspace
	-o	open workspace in vscode
	-a	add in workspace
	-w	workspace details
    -v 	open workspace in vim
    -d  get directory to workspace directory
"
}

function getWorkspacePath() {
	workspace="${workspacePath}/${1}.code-workspace"
} 

function checkWorkspace() {
	local workspaces=$(ls $workspacePath | awk -F. '{print $1}')
	workspaces=( $workspaces )
	b=0
	for (( i=0; i<${#workspaces[@]}; i++ )); do
		if [[ $workspaceName == ${workspaces[$i]} ]]; then 
			b=1
			break
		fi
	done
	echo $b
}

function checkIfWorkspaceExists() {
	local exists=$(checkWorkspace)
	if [[ exists -eq 0 ]]; then 
		echo "Workspace doesn't exists"
		echo "Get all workspace: vscode_workspace_manager.sh -s"
		exit 1
	fi
}

function showAllWorkspace() {
	echo "Workspaces you have:"
	ls $workspacePath | awk -F. 'END {print "Total: "NR} {print $1}'
}

function createWorkspace() {
	local exists=$(checkWorkspace)
	if [[ exists -eq 1 ]]; then 
		echo "Workspace already exists"
		exit 1
	fi
	local workspace=""
	getWorkspacePath $workspaceName $workspace
	echo "Creating workspace ${workspaceName}"
	echo "Location: ${projectPath}"
	sed 's|""|"'${projectPath}'",|' $workspaceTemplate > $workspace
}

function addInWorkspace() {
	checkIfWorkspaceExists
	local workspace=""
	getWorkspacePath $workspaceName $workspace
	local tailLoc=$(awk '/"path": / {print $NF}' $workspace | tail -n 1)
	echo "Workspace ${workspaceName}"
	echo "Adding project: ${projectPath}"
	sed -i 's|'${tailLoc}'|'${tailLoc}'\n\t\t\t"path": "'${projectPath}'",|' "${workspacePath}/${workspaceName}.code-workspace"
}

function removeWorkspace() {
	checkIfWorkspaceExists
	read -p "Do you really want to remove $workspaceName [y,N]:" remove
	if [[ $remove == 'y' || $remove == 'Y' ]]; then 
		local workspace=""
		getWorkspacePath $workspaceName $workspace
		rm -r $workspace
		echo "$workspaceName deleted"
		exit 1
	fi
	echo "Aborting..."
	exit 1
}

function getWorkspaceDetails() {
	checkIfWorkspaceExists
	local workspace=""
	getWorkspacePath $workspaceName $workspace
	echo "Projects in Workspace:"
	awk '/"path": / {print $NF}' $workspace | awk -F '"' '{print $2}'
}

function openWorkspace() {
	checkIfWorkspaceExists
	local workspace=""
	getWorkspacePath $workspaceName $workspace
	echo "Opening workspace"
	code $workspace
}

function getWorkspaceWorkingDir() {
	local workspace=""
	getWorkspacePath $workspaceName $workspace
	path=`awk '/"path": / {print $NF}' $workspace | awk -F '"' '{print $2}'`
}

function openWorkspaceVim() {
	checkIfWorkspaceExists
    local path=""
    getWorkspaceWorkingDir $path
	vim $path
}

function echoDirOfWorkspace() {
    checkIfWorkspaceExists
    local path=""
    getWorkspaceWorkingDir $path
    echo $path
}

############### main #################
## flags ##
while getopts hsc:w:a:r:o:v:d: flag; do
	case $flag in 
		h)
			helpFunc
			exit 1 
			;;
		c)
			workspaceName=${OPTARG}
			createWorkspace
			exit 1
			;;
		s)
			showAllWorkspace
			exit 1
			;;
		w)
			workspaceName=${OPTARG}
			getWorkspaceDetails
			exit 1
			;;
		a)
			workspaceName=${OPTARG}
			addInWorkspace
			exit 1
			;;
		r)
			workspaceName=${OPTARG}
			removeWorkspace
			exit 1
			;;
		o)
			workspaceName=${OPTARG}
			openWorkspace
			exit 1
			;;
		v)
			workspaceName=${OPTARG}
			openWorkspaceVim
			exit 1
			;;
		d)
			workspaceName=${OPTARG}
			echoDirOfWorkspace
			exit 1
			;;
		*)
			echo "Invalid options"
			echo "Get help:"
			echo "vscode_workspace_manager.sh -h"
			exit 1
			;;
	esac
done

## banner ##
banner
echo "Description:
VScode workspace manager

Get help:
vscode_env_controller.sh -h
"
