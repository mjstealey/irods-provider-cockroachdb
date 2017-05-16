# irods-provider-cockroachdb
iRODS provider using CockroachDB as ICAT backend in Docker

**Work in progress**

Does not work at this time


**TODO**: Starting from:

```
+-------------------------+
| Setting up the database |
+-------------------------+

Listing database tables...
Creating database tables...
Traceback (most recent call last):
  File "/var/lib/irods/scripts/setup_irods.py", line 448, in <module>
    sys.exit(main())
  File "/var/lib/irods/scripts/setup_irods.py", line 436, in main
    setup_server(irods_config, json_configuration_file=options.json_configuration_file)
  File "/var/lib/irods/scripts/setup_irods.py", line 123, in setup_server
    database_interface.setup_catalog(irods_config, default_resource_directory=default_resource_directory)
  File "/var/lib/irods/scripts/irods/database_interface.py", line 23, in setup_catalog
    database_connect.create_database_tables(irods_config, cursor)
  File "/var/lib/irods/scripts/irods/database_connect.py", line 327, in create_database_tables
    execute_sql_file(sql_file, cursor, by_line=True)
  File "/var/lib/irods/scripts/irods/database_connect.py", line 231, in execute_sql_file
    cursor.execute(line)
  File "/var/lib/irods/scripts/irods/pypyodbc.py", line 1608, in execute
    self.execdirect(query_string)
  File "/var/lib/irods/scripts/irods/pypyodbc.py", line 1634, in execdirect
    check_success(self, ret)
  File "/var/lib/irods/scripts/irods/pypyodbc.py", line 986, in check_success
    ctrl_err(SQL_HANDLE_STMT, ODBC_obj.stmt_h, ret, ODBC_obj.ansi)
  File "/var/lib/irods/scripts/irods/pypyodbc.py", line 954, in ctrl_err
    raise ProgrammingError(state,err_text)
irods.pypyodbc.ProgrammingError: ('42S01', '[42S01] Error creating the table')
```