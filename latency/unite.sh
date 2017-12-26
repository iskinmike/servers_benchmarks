#!/bin/bash


# Нужно найти файлы

# Нужно их скопировать в каталог


rm *.dat.pc
dat_files=$(ls *.png.dat)

header_line="test"

tmp_file="tmp.txt"
mutual_file="mutual.txt"
names_file="names.txt"
file_names_file="file_names.txt"

rm -f $tmp_file
rm -f $tmp_file.pc
rm -f $mutual_file
rm -f $tmp_file.pc
rm -f $names_file.pc
rm -f $file_names_file.pc

plot_line="plot '$mutual_file' using 2:xtic(1) ti col"

counter=1
for i in $dat_files; do
	# echo $i
	counter=$(( counter+1 ))
	if [[ "$counter" != "2" ]]; then
		plot_line=$( echo "$plot_line, '' u $counter ti col " )
	fi
	########

	name=$(echo $i | sed 's/\.latency\.png\.dat//')
	echo "$name" >> $names_file
	echo "$i" >> $file_names_file
	sed "s/Server/$name/" $i >> $i.pc
	# echo $name
	# plot_line=$(echo "$plot_line '$i.pc' using 2:xtic(1) ti col,")
	header_line=$(echo "$header_line  $name")

	cat $i | tail -n +2 | while read first second
	do
		echo $first >> $tmp_file
	done
done


sort -u $tmp_file >> $tmp_file.pc
sort -u $names_file >> $names_file.pc
sort -u $file_names_file >> $file_names_file.pc


# echo $header_line
echo $plot_line

python "unite.py"
