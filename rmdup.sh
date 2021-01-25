#!/bin/bash
#How to run: bash rmdup.sh module_name
#folder_path - path to the folder with generated configuration. $1 is the input parameter denoting module name. If $2 argument is sync it means that the existing config will be removed from sync folder.
if [ $2 = 'sync' ]
then
	folder_path='config/sync';
else
	folder_path=lib/modules/$1/config/install;
fi
echo "Removing existing config files in $folder_path"
msg=$((drush en $1)2>&1)
output=$(echo "$msg" | tr -d \\0 | grep -z -o "\((.*)\)" | grep -z -o "[^(].*[^)]")
output_normalized=$(echo $output | tr -d '[:space:]')
IFS=',' read -a files <<<$output_normalized
for i in "${files[@]}"
do
	echo "Removing $i"
	#Use sudo rm if you need root privileges.
	rm -f $folder_path/$i.yml
done
