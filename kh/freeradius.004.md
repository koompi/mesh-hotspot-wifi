```
DEV: 001
Title: Freeradius
Author: Heng Hongsea
Status: Active
Create: 2020-06-16
Update: NA
version: 0.1.0
```

# **Freeradius**

## Node Master

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

Look this: [sql](/kh/sql)

### Link  `mods-available` to `mods-enabled` following 

```console
sudo ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/sql
```

### Add user and password to sql in table `radcheck`

Go to postgresql and insert this user for test. This is simple create user with Cleartext-Password. 

```console
INSERT INTO radcheck VALUES (1, 'demo', 'Cleartext-Password', ':=', '123');
```

We will insert user with password encryption MD5

```console
INSERT INTO radcheck (username ,attribute ,op ,value ) VALUES ('user0', 'MD5-Password', ':=', MD5( '123' ));
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

### If you meet error with port already in use, fix it by following 

```console
sudo lsof -Pni:1812
sudo kill -9 PIN
```

### Test connection freeradius with postgresql

Test user demo with password 123 

```console
radtest demo 123 localhost 0 testing123
```

### Add connection with client in this path:  `/etc/freeradius/3.0/clients.conf`

```console
client RPiNode1 {
	ipaddr		= 192.168.20.1
	secret		= 123
}

```

### sqlcounter

following this path: /etc/freeradius/3.0/mods-available/sqlcounter

Look this: [sqlcounter](/kh/sqlcounter)

user `usera` login timeout in 2mn. This time will start running from login.
*Note: Not yet have reset time.*

### Access-Period

user can run 10 minute

```console
INSERT INTO radcheck (username ,attribute ,op ,value ) VALUES ('user0', 'MD5-Password', ':=', MD5( '123' ));
INSERT INTO radcheck (username ,attribute ,op ,value ) VALUES ('user0', 'Access-Period', ':=', '60');
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

