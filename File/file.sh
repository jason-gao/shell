#!/bin/bash

# file
file="./test.txt"
if [ ! -f "$file" ]; then
	touch "$file"
fi


#folder
folder="./test"
if [ ! -d "$folder" ]; then
	mkdir "$folder"
fi