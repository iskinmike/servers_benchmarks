import os

import re
from copy import deepcopy
import copy


names_dict = {}
tests_dict = {}



# result_string = "test"


names = open('./names.txt.pc')
for line in names.readlines():
	name = line.replace('\n','')
	names_dict[name] = "-";

tests = open('./tmp.txt.pc')
for line in tests.readlines():
	tmp_dict = copy.deepcopy(names_dict)
	tests_dict[line.replace('\n','')] = tmp_dict

files = open('./file_names.txt.pc')
for line in files.readlines():
	path = "./" + line.replace('\n','')
	# print(path)
	dat_file = open(path)
	for dat_line in dat_file.readlines():
		# print (dat_line.replace('\n',''))
		if ((dat_line.find("GET") != -1) or (dat_line.find("POST") != -1)):
			values=dat_line.split(" ");
			test_str=values[0]
			name_str=line.replace(".latency.png.dat",'').replace('\n','')
			tests_dict[test_str][name_str] = values[1].replace('\n','')
			pass

# print(tests_dict)

result_string="test"
for elem in tests_dict[tests_dict.keys()[0]]:
	result_string += " " + elem
	pass

for line in tests_dict:
	result_string += "\n" + line
	for elem in tests_dict[line]:
		result_string += "  " + tests_dict[line][elem]
		pass
	pass

# print(result_string)


mutual = open('./mutual.txt', 'w')
mutual.write(result_string)


