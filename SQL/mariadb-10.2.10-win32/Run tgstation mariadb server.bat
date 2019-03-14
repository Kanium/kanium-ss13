@echo off

echo "Press any key to start the MariaDB DataBase Server. After it starts, Press control+c in here to shut the server down."
pause
REM The command line is used rather then a config file because if no config file is present, it forces mysql into standalone mode and all file paths become relative 
bin\mysqld.exe --bind_address=127.0.0.1 --bulk_insert_buffer_size=0 --console --host_cache_size=2 --innodb-autoextend-increment=1 --innodb-data-file-path=ibdata1:1M:autoextend --innodb-defragment=1 --innodb_buffer_pool_size=1M --innodb_file_format=Barracuda --innodb_file_per_table=1 --innodb_flush_log_at_trx_commit=1 --innodb_ft_cache_size=1600000 --innodb_ft_total_cache_size=32000000 --innodb_log_buffer_size=256K --innodb_log_file_size=1M --innodb_sort_buffer_size=64K --innodb_temp_data_file_path=ibtmp1:1M:autoextend --join_buffer_size=128 --key_buffer_size=8 --lower_case_table_names=1 --max_allowed_packet=1M --max_connections=8 --max_heap_table_size=16K --net_buffer_length=1K --performance_schema=off --port=3306 --query_cache_limit=64k --query_cache_size=4M --query_cache_type=1 --read_buffer_size=8200 --read_rnd_buffer_size=8200 --skip-external-locking --sort_buffer_size=32K --symbolic-links=0 --table_open_cache=4 --thread_cache_size=2 --thread_stack=131072 --tmp_table_size=1K

echo " "
echo "The MariaDB DataBase Server has stopped. If you did not intend for that to happen, the Error log is located at data\computername.err"
pause