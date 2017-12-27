#!/bin/bash

./servers_test.sh -- "" node "./node_server/server.js" node_test_1 http://127.0.0.1:8080/index.html wrk_test_params.txt
./servers_test.sh -- "" node "./node_server/server.js" node_test_2 http://127.0.0.1:8080/index.html wrk_test_params.txt
./servers_test.sh -- "" node "./node_server/server.js" node_test_3 http://127.0.0.1:8080/index.html wrk_test_params.txt
./servers_test.sh -- "" node "./node_server/server.js" node_test_4 http://127.0.0.1:8080/index.html wrk_test_params.txt

./servers_test.sh -- ../main/wilton/build/wilton_201712220/bin/ wilton ./js_wilton_server/index.js js_wilton_test_4_thr_1 http://127.0.0.1:8080/js_wilton_server/views/hi wrk_test_params.txt
./servers_test.sh -- ../main/wilton/build/wilton_201712220/bin/ wilton ./js_wilton_server/index.js js_wilton_test_4_thr_2 http://127.0.0.1:8080/js_wilton_server/views/hi wrk_test_params.txt
./servers_test.sh -- ../main/wilton/build/wilton_201712220/bin/ wilton ./js_wilton_server/index.js js_wilton_test_4_thr_3 http://127.0.0.1:8080/js_wilton_server/views/hi wrk_test_params.txt
./servers_test.sh -- ../main/wilton/build/wilton_201712220/bin/ wilton ./js_wilton_server/index.js js_wilton_test_4_thr_4 http://127.0.0.1:8080/js_wilton_server/views/hi wrk_test_params.txt

./servers_test.sh -- ./golang_server/ golang_server "proxy" golang_test_1 http://127.0.0.1:8080/index.html wrk_test_params.txt
./servers_test.sh -- ./golang_server/ golang_server "proxy" golang_test_2 http://127.0.0.1:8080/index.html wrk_test_params.txt
./servers_test.sh -- ./golang_server/ golang_server "proxy" golang_test_3 http://127.0.0.1:8080/index.html wrk_test_params.txt
./servers_test.sh -- ./golang_server/ golang_server "proxy" golang_test_4 http://127.0.0.1:8080/index.html wrk_test_params.txt

./servers_test.sh -- ./wilton_server/ test_server 4 wilton_server_test_1 http://127.0.0.1:8080/index.html wrk_test_params.txt
./servers_test.sh -- ./wilton_server/ test_server 4 wilton_server_test_2 http://127.0.0.1:8080/index.html wrk_test_params.txt
./servers_test.sh -- ./wilton_server/ test_server 4 wilton_server_test_3 http://127.0.0.1:8080/index.html wrk_test_params.txt
./servers_test.sh -- ./wilton_server/ test_server 4 wilton_server_test_4 http://127.0.0.1:8080/index.html wrk_test_params.txt