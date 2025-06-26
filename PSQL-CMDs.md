PGPASSWORD=changeme psql -h 192.168.2.239 -U jomoon pgsql_testdb -c " select inet_server_addr( ), inet_server_port( );"

