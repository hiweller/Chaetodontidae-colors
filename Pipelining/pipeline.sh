#!/bin/bash

# provide max number of clusters and output folder
c=50

# folder full of images you want to analyze
in=/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/Figures/GreenImages/

# folder in which you want to store all the subfolders (script creates 1 folder per cluster within this folder, each of which contains all the output images + the out.csv with the RGB, percent, and inertia values)
out=/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/Figures/Output/

for i in $(seq 10 10 $c)
do
	mkdir -p "${out}${i}Color"
	outfolder=${out}${i}Color/
	python /Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/Code/Python\ Scripts/fish_loops.py -f ${in} -o ${outfolder} -c ${i}
done
