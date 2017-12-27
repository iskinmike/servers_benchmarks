#!/bin/bash

# Данный скрипт предназначен для запуска тестирования серверов под нагрузкой


# Собираемая информация:
# 1. Загрузка CPU во время теста
# 2. Использование памяти во время теста
# 3. Результаты отработки wrk


# Алгоритм работы:

# 1. Запускаем сервер. В отдельном терминале? Так же диагностику CPU и диагностику Памяти в отдельном терминале?
# 2. делаем паузу чтобы сервак успел запуститься
# 3. Получаем начальные параметры тестирования
# 4. Запускаем wrk с этими параметрами
# 5. После отработки сохраняем данные.
# 6. Меняем параметры
# 7. Возвращаемся к пункту 4.

usage="Usage: $0 [-test] -- server_directory server_name args store_directory server_url wrk_parameters_file\n
\n
-test - Флаг, который остановит выполнение скрипта после попытки запустить сервер.\n
        \t У пользователя будет возможность проверить запустился ли сервер.\n
        \t Если сервер не запустился - введите q для выхода из скрипта.\n
        \t Если сервер запустился - любой ввод отличный от q продолжит выполнение скрипта.\n
"


# if [[ "$1" = "--help" ]]
# then
# 	echo "Usage: $0 server_directory server_name args store_directory [--test]"
# 	echo ""
# 	echo "  --test - Флаг, который остановит выполнение скрипта после попытки запустить сервер."
# 	echo "           У пользователя будет возможность проверить запустился ли сервер."
# 	echo "           Если сервер не запустился - введите q для выхода из скрипта."
# 	echo "           Если сервер запустился - любой ввод отличный от q продолжит выполнение скрипта."
# 	exit 0
# fi

test_mode="OFF"
while [ -n "$1" ]
do
case "$1" in
-test) test_mode="ON" ;; 
-help) echo -e $usage; exit 0 ;;
--) shift
break ;;
*) echo "$1 is not an option";;
esac
shift
done


echo "========================="

server_name=$2
store_directory=$4

rm -rf $store_directory
mkdir -p $store_directory

# Запускаем сервер в фоновом режиме. На вход первый параметр должен передать команду запуска сервера
$1$server_name $3 & 

echo "$1"
echo "$2"
echo "$3"
echo "$4"
echo "$5"

if [[ "$test_mode" = "ON" ]] 
then
	echo "enter q to exit"
	read doing #здесь мы читаем в переменную $doing со стандартного ввода
	echo "eh: $doing"
	if [[ "$doing" = 'q' ]] 
	then
		echo "exit"
		count=1
		jobs -p | while read tmp_pid
		do
		echo "pid[$count]: $tmp_pid"
		count=$(( $count + 1 ))
		kill $tmp_pid
		done
		exit 0
	fi
fi


wrk_file="wrkstat.txt"
vm_file="vmstat.txt"
mp_file="mpstat.txt"
io_file="iostat.txt"
free_file="freestat.txt"
top_file="topstat.txt"


# Запускаем диагностику cpu
vmstat -w 1 >> ./$store_directory/$vm_file &

# Запускаем диагностику памяти
mpstat 1 >> ./$store_directory/$mp_file &

# Запускаем диагностику ввода/вывода
iostat -h -y -d 1 >> ./$store_directory/$io_file &

# Запускаем диагностику памяти под free
free -m -s 1 >> ./$store_directory/$free_file &

current_user=$(whoami)
# Запускаем диагностику памяти под free
top -b -u $current_user -d 1 >> ./$store_directory/$top_file &

jobs -l

sleep 5s

echo "========================="
echo "Let's do some LOAD"
# # Запускаем нагрузку

wrk_path="./wrk"
# server_url="http://127.0.0.1:8080/index.html"
# server_url="http://127.0.0.1:8080/js_wilton_server/views/hi"
server_url=$5
wrk_test_data_file=$6  #"wrk_test_params.txt"


cat $wrk_test_data_file | tail -n +2 | while read threads delim connections delim seconds delim  query
do
	echo "Run with params: $threads, $connections, $seconds, $query" >> ./$store_directory/$wrk_file

	echo "Run with params: $threads, $connections, $seconds, $query" >> ./$store_directory/$vm_file
	echo "Run with params: $threads, $connections, $seconds, $query" >> ./$store_directory/$mp_file
	echo "Run with params: $threads, $connections, $seconds, $query" >> ./$store_directory/$io_file
	echo "Run with params: $threads, $connections, $seconds, $query" >> ./$store_directory/$free_file
	echo "Run with params: $threads, $connections, $seconds, $query" >> ./$store_directory/$top_file

	echo "Run with params: threads=$threads, connections=$connections, seconds=$seconds, query=$query"

	if [[ "$query" = "GET" ]]
	then
		$wrk_path/wrk -t"$threads" -c"$connections" -d"$seconds"s $server_url >> ./$store_directory/$wrk_file
	else
		$wrk_path/wrk -t"$threads" -c"$connections" -d"$seconds"s -s"$wrk_path/scripts/post.lua" $server_url >> ./$store_directory/$wrk_file
	fi
	echo "=========================" >> ./$store_directory/$wrk_file
	echo "" >> ./$store_directory/$wrk_file

	echo "End Run" >> ./$store_directory/$vm_file
	echo "End Run" >> ./$store_directory/$mp_file
	echo "End Run" >> ./$store_directory/$io_file
	echo "End Run" >> ./$store_directory/$free_file
	echo "End Run" >> ./$store_directory/$top_file

	sleep 15s
done


echo "========================="
count=1
jobs -p | while read tmp_pid
do
echo "pid[$count]: $tmp_pid"
count=$(( $count + 1 ))
kill $tmp_pid
done
echo "========================="

# Теперь запустим обработку данных
# Нужно отдельно обработать iostat.txt
sed '/Device/d; /sda/d; /^$/d' ./$store_directory/$io_file >> ./$store_directory/$io_file.pc

# Нужно отдельно обработать freestat.txt
sed '/buffers/d; /Swap/d; /^$/d' ./$store_directory/$free_file >> ./$store_directory/$free_file.pc

# Нужно отдельно обработать vmstat.txt
sed '/procs/d; /free/d; /^$/d' ./$store_directory/$vm_file >> ./$store_directory/$vm_file.pc

# Нужно отдельно обработать mpstat.txt
sed '/CPU/d; /^$/d' ./$store_directory/$mp_file >> ./$store_directory/$mp_file.pc

# Нужно отдельно обработать topstat.txt
echo "$server_name"
sed 's/End Run/\nEnd/;' ./$store_directory/$top_file | sed 's/Run/\nRun/' | sed -n '/wrk/p; /Run/p; /End/p' >> ./$store_directory/$top_file.pc.wrk
sed 's/End Run/\nEnd/;' ./$store_directory/$top_file | sed 's/Run/\nRun/' | sed -n "/$server_name/p; /Run/p; /End/p" >> ./$store_directory/$top_file.pc.server

# Обработаетм wrkstat.txt
sed -n 's/Run/Run/p; s/Latency/Latency/p' ./$store_directory/$wrk_file | sed '/test/d' | sed 's/Run/End\nRun/g' >> ./$store_directory/$wrk_file.latency
sed -n 's/Run/Run/p; s/Requests\/sec/Requests\/sec/p' ./$store_directory/$wrk_file | sed '/test/d' | sed 's/Run/End\nRun/g' >> ./$store_directory/$wrk_file.requests


echo "End" >> ./$store_directory/$wrk_file.latency
echo "End" >> ./$store_directory/$wrk_file.requests

# Cоздадим каталог
work_dat_path=$store_directory/work_dat

mkdir -p $work_dat_path

# Конкретика не из файлов, а пока так просто
cpu_load_pos=3
free_mem_pos=4
io_data_pos=5

top_cpu_usage_pos=9
top_mem_usage_pos=6


latency_pos=2
req_freq_pos=2

plots_path="$store_directory/plots"
mkdir -p $plots_path

# Вызовы для файлов 
./test_gather.sh $work_dat_path $store_directory/$mp_file.pc $cpu_load_pos ./$plots_path/cpu_load.png -rm
./test_gather.sh $work_dat_path $store_directory/$vm_file.pc $free_mem_pos ./$plots_path/vm_mem.png -rm
./test_gather.sh $work_dat_path $store_directory/$io_file.pc $io_data_pos ./$plots_path/io_stat.png -rm
./test_gather.sh $work_dat_path $store_directory/$free_file.pc $free_mem_pos ./$plots_path/free_mem.png -rm

./test_gather.sh $work_dat_path $store_directory/$top_file.pc.server $top_cpu_usage_pos ./$plots_path/$server_name-cpu_usage.png -rm
./test_gather.sh $work_dat_path $store_directory/$top_file.pc.server $top_mem_usage_pos ./$plots_path/$server_name-mem_usage.png -rm

./test_gather.sh $work_dat_path $store_directory/$top_file.pc.wrk $top_cpu_usage_pos ./$plots_path/wrk_cpu_usage.png -rm
./test_gather.sh $work_dat_path $store_directory/$top_file.pc.wrk $top_mem_usage_pos ./$plots_path/wrk_mem_usage.png -rm

./test_gather.sh $work_dat_path $store_directory/$wrk_file.latency $latency_pos ./$plots_path/latency.png -rm --hist
./test_gather.sh $work_dat_path $store_directory/$wrk_file.requests $req_freq_pos ./$plots_path/requests.png -rm --hist
