docker exec -t cobra_db_1 pg_dumpall -c -U postgres > ~/dump_`date +%Y-%m-%d"_"%H_%M_%S`.sql
