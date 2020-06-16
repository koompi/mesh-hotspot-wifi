```
DEV: 001
Title: Freeradius
Author: Heng Hongsea
Status: Active
Create: 2020-06-15
Update: NA
version: 0.1.0
```

# Freeradius

## Freeradius on server

### Install package

```console
sudo apt install freeradius freeradius-postgresql
```

### Create database on postgresql

we already setup postgresql and adminer on docker, run `http://ip_server:port` , login username `adminer` password `adminer` and create new database name `radius`.

### Import tables to database `radius`

go to directory on freeradius in this path:  `/etc/freeradius/3.0/mods-config/sql/main/postgresql/`
```console
schema.sql
setup.sql
```

### Change `'-sql' to sql ` in this path: `/etc/freeradius/3.0/sites-available/default`

```console
authorize {
#   files
    sql
}
authenticate {
}
preacct {
#   files
}
accounting {
    sql
}
session {
    sql
}
post-auth {

    ...

    sql

    ...

    Post-Auth-Type REJECT {
    # log failed authentications in SQL, too.
    sql
    attr_filter.access_reject
    }
}
```

### change  `-sql` to  `sql` in this path:  `/etc/freeradius/3.0/sites-available/inner-tunnel`

```console
authorize{
sql
}

authenticate{
}

session{
sql
}

post-auth{

...
sql
..

        Post-Auth-Type REJECT {
                # log failed authentications in SQL, too.
                sql
                ...
     }           
}
```

### Link  `sites-available` to  `sites-enabled`

```console
sudo ln -s /etc/freeradius/3.0/sites-avaiable/default /etc/freeradius/3.0/sites-enabled/default
sudo ln -s /etc/freeradius/3.0/sites-available/inner-tunner /etc/freeradius/3.0/sites-enabled/inner-tunner
```

### connect freeradius with postgresql. You need edit in this path:  `/etc/freeradius/3.0/mods-available/sql`.

```console
# -*- text -*-
##
## sql.conf -- SQL modules
##
##      $Id: 4a59483c35c77f573fb177919e19ba4434cc3da1 $

######################################################################
#
#  Configuration for the SQL module
#
#  The database schemas and queries are located in subdirectories:
#
#       sql/<DB>/main/schema.sql        Schema
#       sql/<DB>/main/queries.conf      Authorisation and Accounting queries
#
#  Where "DB" is mysql, mssql, oracle, or postgresql.
#
#

sql {
        # The sub-module to use to execute queries. This should match
        # the database you're attempting to connect to.
        #
        #    * rlm_sql_mysql
        #    * rlm_sql_mssql
        #    * rlm_sql_oracle
        #    * rlm_sql_postgresql
        #    * rlm_sql_sqlite
        #    * rlm_sql_null (log queries to disk)
        #
        driver = "rlm_sql_postgresql"

#
#       Several drivers accept specific options, to set them, a
#       config section with the the name as the driver should be added
#       to the sql instance.
#
#       Driver specific options are:
#
#       sqlite {
#               # Path to the sqlite database
#               filename = "/tmp/freeradius.db"
#
#               # How long to wait for write locks on the database to be
#               # released (in ms) before giving up.
#               busy_timeout = 200
#
#               # If the file above does not exist and bootstrap is set
#               # a new database file will be created, and the SQL statements
#               # contained within the bootstrap file will be executed.
#               bootstrap = "${modconfdir}/${..:name}/main/sqlite/schema.sql"
#       }
#
#       mysql {
#               # If any of the files below are set, TLS encryption is enabled
#               tls {
#                       ca_file = "/etc/ssl/certs/my_ca.crt"
#                       ca_path = "/etc/ssl/certs/"
#                       certificate_file = "/etc/ssl/certs/private/client.crt"
#                       private_key_file = "/etc/ssl/certs/private/client.key"
#                       cipher = "DHE-RSA-AES256-SHA:AES128-SHA"
#               }
#
#               # If yes, (or auto and libmysqlclient reports warnings are
#               # available), will retrieve and log additional warnings from
#               # the server if an error has occured. Defaults to 'auto'
#               warnings = auto
#       }
#
#       postgresql {
#
#               # unlike MySQL, which has a tls{} connection configuration, postgresql
#               # uses its connection parameters - see the radius_db option below in
#               # this file
#
#               # Send application_name to the postgres server
#               # Only supported in PG 9.0 and greater. Defaults to no.
#               send_application_name = yes
#       }
#

        # The dialect of SQL you want to use, this should usually match
        # the driver you selected above.
        #
        # If you're using rlm_sql_null, then it should be the type of
        # database the logged queries are going to be executed against.
        dialect = "postgresql"

        # Connection info:
        #
        server = "<ip address>"
        port = 5432
        login = "username"
        password = "password"

        # Database table configuration for everything except Oracle
        radius_db = "radius"

        # If you are using Oracle then use this instead
#       radius_db = "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SID=your_sid)))"

        # If you're using postgresql this can also be used instead of the connection info parameters
#       radius_db = "dbname=radius host=localhost user=radius password=raddpass"

        # Postgreql doesn't take tls{} options in its module config like mysql does - if you want to
        # use SSL connections then use this form of connection info parameter
#       radius_db = "host=localhost port=5432 dbname=radius user=radius password=raddpass sslmode=verify-full sslcert=/etc/ssl/client.crt sslkey=/etc/ssl/client.key sslrootcert=/etc/ssl/ca.crt" 

        # If you want both stop and start records logged to the
        # same SQL table, leave this as is.  If you want them in
        # different tables, put the start table in acct_table1
        # and stop table in acct_table2
        acct_table1 = "radacct"
        acct_table2 = "radacct"

        # Allow for storing data after authentication
        postauth_table = "radpostauth"

        # Tables containing 'check' items
        authcheck_table = "radcheck"
        groupcheck_table = "radgroupcheck"

        # Tables containing 'reply' items
        authreply_table = "radreply"
        groupreply_table = "radgroupreply"

        # Table to keep group info
        usergroup_table = "radusergroup"

        # If set to 'yes' (default) we read the group tables unless Fall-Through = no in the reply table.
        # If set to 'no' we do not read the group tables unless Fall-Through = yes in the reply table.
#       read_groups = yes

        # If set to 'yes' (default) we read profiles unless Fall-Through = no in the groupreply table.
        # If set to 'no' we do not read profiles unless Fall-Through = yes in the groupreply table.
#       read_profiles = yes

        # Remove stale session if checkrad does not see a double login
        delete_stale_sessions = yes

        # Write SQL queries to a logfile. This is potentially useful for tracing
        # issues with authorization queries.  See also "logfile" directives in
        # mods-config/sql/main/*/queries.conf.  You can enable per-section logging
        # by enabling "logfile" there, or global logging by enabling "logfile" here.
        #
        # Per-section logging can be disabled by setting "logfile = ''"
#       logfile = ${logdir}/sqllog.sql

        #  Set the maximum query duration and connection timeout
        #  for rlm_sql_mysql.
#       query_timeout = 5

        #  As of version 3.0, the "pool" section has replaced the
        #  following configuration items:
        #
        #  num_sql_socks
        #  connect_failure_retry_delay
        #  lifetime
        #  max_queries

        #
        #  The connection pool is new for 3.0, and will be used in many
        #  modules, for all kinds of connection-related activity.
        #
        # When the server is not threaded, the connection pool
        # limits are ignored, and only one connection is used.
        #
        # If you want to have multiple SQL modules re-use the same
        # connection pool, use "pool = name" instead of a "pool"
        # section.  e.g.
        #
        #       sql1 {
        #           ...
        #           pool {
        #                ...
        #           }
        #       }
        #
        #       # sql2 will use the connection pool from sql1
        #       sql2 {
        #            ...
        #            pool = sql1
        #       }
        #
        pool {
                #  Connections to create during module instantiation.
                #  If the server cannot create specified number of
                #  connections during instantiation it will exit.
                #  Set to 0 to allow the server to start without the
                #  database being available.
                start = ${thread[pool].start_servers}

                #  Minimum number of connections to keep open
                min = ${thread[pool].min_spare_servers}

                #  Maximum number of connections
                #
                #  If these connections are all in use and a new one
                #  is requested, the request will NOT get a connection.
                #
                #  Setting 'max' to LESS than the number of threads means
                #  that some threads may starve, and you will see errors
                #  like 'No connections available and at max connection limit'
                #
                #  Setting 'max' to MORE than the number of threads means
                #  that there are more connections than necessary.
                max = ${thread[pool].max_servers}

                #  Spare connections to be left idle
                #
                #  NOTE: Idle connections WILL be closed if "idle_timeout"
                #  is set.  This should be less than or equal to "max" above.
                spare = ${thread[pool].max_spare_servers}

                #  Number of uses before the connection is closed
                #
                #  0 means "infinite"
                uses = 0

                #  The number of seconds to wait after the server tries
                #  to open a connection, and fails.  During this time,
                #  no new connections will be opened.
                retry_delay = 30

                # The lifetime (in seconds) of the connection
                lifetime = 0

                #  idle timeout (in seconds).  A connection which is
                #  unused for this length of time will be closed.
                idle_timeout = 60

                #  NOTE: All configuration settings are enforced.  If a
                #  connection is closed because of "idle_timeout",
                #  "uses", or "lifetime", then the total number of
                #  connections MAY fall below "min".  When that
                #  happens, it will open a new connection.  It will
                #  also log a WARNING message.
                #
                #  The solution is to either lower the "min" connections,
                #  or increase lifetime/idle_timeout.
        }

        # Set to 'yes' to read radius clients from the database ('nas' table)
        # Clients will ONLY be read on server startup.
#       read_clients = yes

        # Table to keep radius client info
        client_table = "nas"

        #
        # The group attribute specific to this instance of rlm_sql
        #

        # This entry should be used for additional instances (sql foo {})
        # of the SQL module.
#       group_attribute = "${.:instance}-SQL-Group"

        # This entry should be used for the default instance (sql {})
        # of the SQL module.
        group_attribute = "SQL-Group"

        # Read database-specific queries
#       $INCLUDE ${modconfdir}/${.:name}/main/${dialect}/queries.conf
        $INCLUDE /etc/freeradius/3.0/mods-config/sql/main/postgresql/queries.conf
}
```

### Link  `mods-available` to `mods-enabled` following 

```console
sudo ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/sql
```

### Add user and password to sql in table `radcheck`

```console
INSERT INTO radcheck VALUES (1, 'demo', 'Cleartext-Password', ':=', '123');
```

### Start service freeradius

```console
sudo systemctl enable freeradius
sudo systemctl start freeradius
```

### Run debug
```console
sudo systemctl stop freeradius
sudo freeradius -X
```

### Import sql

[postgresql](/sql/)

### If you meet error with port already in use, fix it by following 

```console
sudo lsof -Pni:1812
sudo kill -9 PIN
```

### Test connection freeradius with postgresql

```console
radtest demo 123 localhost 0 testing123
```

### Add connection with client in this path:  `/etc/freeradius/3.0/clients.conf`

```console
client RPiNode1 {
	ipaddr		= <ip client>
	secret		= <secret>
}

```

### sqlcounter

following this path: /etc/freeradius/3.0/mods-available/sqlcounter

user `usera` login timeout in 2mn. This time will start running from login.
*Note: Not yet have reset time.*

### Access-Period

user can run 10 minute

```console
INSERT INTO radcheck VALUES (9, 'userd', 'Cleartext-Password', ':=', '123');
INSERT INTO radcheck VALUES (10, 'userd', 'Access-Period', ':=', '60');
```

### Simultaneous-Use

Now open /usr/local/etc/raddb/sites-available/default and uncomment **sql** lines inside authorize, accounting and session sections. You can uncomment sql inside post-auth section too if you want to log login attempts (notice that this is not recommended for production servers. Your database can grow and eat up all free space in case someone tries to brute force your NAS.).

Then comment the next lines: **files** inside authorize section, **detail**, **unix** and **radutmp** inside accounting section and **radutmp** inside session section.

Please note that those lines we commented above are not important for now and commenting those lines can improve performance. Also, note that **detail** should remain uncommented in case you want to create ‘detail’ed log of the packets for accounting requests. You will need this in case you want to proxy accounting to another server.

user can connect 1 device

```console
INSERT INTO radcheck VALUES (35, 'userb', 'Cleartext-Password', ':=', '123');
INSERT INTO radcheck VALUES (36, 'userb', 'Simultaneous-Use', ':=', '1');
```


### Expriy-Account

user `userb` and `userc` login expiry in 1 day. This time will start running from login 

```console
INSERT INTO radcheck VALUES (9, 'userc', 'Simultaneous-Use', ':=', '1');
insert into radcheck values (5,'userc','Cleartext-Password',':=','123');
INSERT INTO radcheck VALUES (6,'userc','Expiration',':=','Apr 30 2020');
insert into radcheck values (7,'userc','Cleartext-Password',':=','123');
INSERT INTO radcheck VALUES (8,'userc',`Expire-After',':=','May 12 2020 04:7:00');
```


### dailycounter
```
insert into radcheck values (2,'userb','Cleartext-Password',':=','123');
insert into radcheck values (3,'userc','Cleartext-Password',':=','123');
insert into radcheck values (5,'userb','Expire-After',':=','120');
insert into radcheck values (5,'userb','Reply-Message',':=','you got expired');
insert into radcheck values (6,'userc','Cleartext-Password',':=','123');
insert into radcheck values (7,'userc','Expiration',':=','120');
INSERT INTO radcheck VALUES ( 7 , 'userd', 'Cleartext-Password', ':=', '123');
INSERT INTO radcheck VALUES ( 7 , 'userc', 'Max-Data', ':=', '1024k/1024k');
INSERT INTO radcheck VALUES ( 8, 'userc', 'Expire-After', ':=', '120');
INSERT INTO radreply VALUES ( 2, 'userd', 'Expiration', ':=', '120');
INSERT INTO radcheck VALUES ( 2, 'userd', 'Expiration', ':=', '120');
INSERT INTO radcheck VALUES (9, 'userc', 'Access-Period', ':=', '120');
INSERT INTO radreply VALUES (1,'userc', 'Mikrotik-Rate-Limit', ':=', '1024k/1024k');
```

### monthlycounter


### Nas

```
insert into nas (nasname,shortname ,type,ports,secret,server,community,description) values ('172.16.0.0/24','RPiNode2','other',NULL,'Admin2020',NULL,NULL,'Wifi Hotspot');
```


## Freeradius on client
