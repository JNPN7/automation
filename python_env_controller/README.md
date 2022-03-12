# Python virtual environment manager
You can manage your python virtual environment using this script

Description
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

	-a -d: activate and deactivate not working properly need some work

## Activation using function in .bashrc
You can activate your virtual environment by adding function to your .bashrc like you add alias:

	function pyactivate() {
		. $HOME/.pyenv/$1/bin/acitivate
	}

Now, you can just call the function in your terminal to activate your virtual environment

	$ pyactivate <virtual_environment_name>

To deactivate just type deactivate

	$ deactivate
