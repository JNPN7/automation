# Workspace manager
You can manage your workspace using this script

Description
Python virtual envirionment manager

Usage:

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

## Changing directory to workspace
You can change directory to the workspace using a simple step

    $ cd `workspace_manager.sh -d <workspace_name>`	

