#!/bin/bash
#How to run: bash rmconfdup.sh module_name
#folder_path - path to the folder with generated configuration. $1 is the input parameter denoting module name.
folder_path=lib/modules/$1/config/install;

echo "Removing existing config files in $1"
msg=$((drush en $1)2>&1)
output=$(echo "$msg" | tr -d \\0 | grep -z -o "\((.*)\)" | grep -z -o "[^(].*[^)]")
output_normalized=$(echo $output | tr -d '[:space:]')
IFS=',' read -a files <<<$output_normalized
for i in "${files[@]}"
do
	echo "Do you want to remove $i? Type 1 for Yes and 2 for No"
	select yn in "Yes" "No"; do
	    case $yn in
	        Yes ) 
				echo "Removing $i";
				#Use sudo rm if you need root privileges.
				rm -f $folder_path/$i.yml; break;;
			No ) break;;
	    esac
	done
done
