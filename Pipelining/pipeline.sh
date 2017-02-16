#!/bin/bash

# provide max number of clusters and output folder
c=6

# folder full of images you want to analyze
in=/Users/hannah/Dropbox/Colorful_Fishinator/Images/

# folder in which you want to store all the subfolders (script creates 1 folder per cluster within this folder, each of which contains all the output images + the out.csv with the RGB, percent, and inertia values)
out=/Users/hannah/Dropbox/Colorful_Fishinator/Out/

for i in $(seq 1 $c)
do
	mkdir -p "${out}0${i}Color"
	outfolder=${out}0${i}Color/
	python /Users/hannah/Dropbox/Colorful_Fishinator/Code/Python\ Scripts/fish_loops.py -f ${in} -o ${outfolder} -c ${i}
done

# clusterFish ()
# {
#
# }
