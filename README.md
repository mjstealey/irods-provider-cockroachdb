# irods-provider-cockroachdb
iRODS provider using CockroachDB as ICAT backend in Docker

**WORK IN PROGRESS**

Currently makes use of a PostgreSQL database as a placeholder for CockroachDB.

## Build / Run

A `docker-compose.yml` files has been provided which creates two containers, one for the **database** and one for **irods**.

The containers can be launched with:

```
docker-compose up -d
```

- **Note** if you want to view the output of the container shells as they stand up leave off the `-d` argument.

Once running the user should observe the following:

```console
$ docker-compose ps
  Name                Command               State                                            Ports
--------------------------------------------------------------------------------------------------------------------------------------------
database   docker-entrypoint.sh postgres    Up      5432/tcp
irods      /usr/local/bin/tini -- /do ...   Up      1247/tcp, 1248/tcp, 20000/tcp, 20001/tcp, 20002/tcp, 20003/tcp, 20004/tcp, 20005/tcp,
                                                    20006/tcp, 20007/tcp, 20008/tcp, 20009/tcp, 20010/tcp, 20011/tcp, 20012/tcp, 20013/tcp,
                                                    ...
                                                    20190/tcp, 20191/tcp, 20192/tcp, 20193/tcp, 20194/tcp, 20195/tcp, 20196/tcp, 20197/tcp,
                                                    20198/tcp, 20199/tcp
```

## Usage

Since iRODS is running on the container named `irods`, we need to issue `icommands` from within the container's scope.

### From the container

Get onto the running container as the `irods` user.

```console
$ docker exec -ti -u irods irods /bin/bash
irods@irods:/$
```

Issue icommands:

```console
$ iadmin lz
tempZone
$ iadmin lr
bundleResc
demoResc
$ ilsresc -l
resource name: demoResc
id: 10014
zone: tempZone
type: unixfilesystem
class: cache
location: irods.local.dev
vault: /var/lib/irods/iRODS/Vault
free space:
free space time: : Never
status:
info:
comment:
create time: 01526065369: 2018-05-11.19:02:49
modify time: 01526065369: 2018-05-11.19:02:49
context:
parent:
parent context:
$ ils
/tempZone/home/rods:
```

### From the host

Issue icommands

```console
$ docker exec -ti -u irods irods iadmin lz
tempZone
$ docker exec -ti -u irods irods iadmin lr
bundleResc
demoResc
$ docker exec -ti -u irods irods ilsresc -l
resource name: demoResc
id: 10014
zone: tempZone
type: unixfilesystem
class: cache
location: irods.local.dev
vault: /var/lib/irods/iRODS/Vault
free space:
free space time: : Never
status:
info:
comment:
create time: 01526065369: 2018-05-11.19:02:49
modify time: 01526065369: 2018-05-11.19:02:49
context:
parent:
parent context:
$ docker exec -ti -u irods irods ils
/tempZone/home/rods:
```

### database

Likewise, the database is running from within a container, and the database can be interacted with from within the container's scope.

From inside the container:

```console
$ docker exec -ti -u postgres database psql -d ICAT
psql (10.3 (Debian 10.3-1.pgdg90+1))
Type "help" for help.

ICAT=# \dt;
                List of relations
 Schema |          Name           | Type  | Owner
--------+-------------------------+-------+-------
 public | r_coll_main             | table | irods
 public | r_data_main             | table | irods
 ...
 public | r_user_session_key      | table | irods
 public | r_zone_main             | table | irods
(35 rows)
```

From the host:

```console
$ docker exec -u postgres database psql -d ICAT -c '\dt;'
                List of relations
 Schema |          Name           | Type  | Owner
--------+-------------------------+-------+-------
 public | r_coll_main             | table | irods
 public | r_data_main             | table | irods
 ...
 public | r_user_session_key      | table | irods
 public | r_zone_main             | table | irods
(35 rows)
```

## Items to address

### Dockerfile

1. CockroachDB database plugin
2. CockroachDB client (presently uses `postgresql-client`)
3. dependencies for plugin

### docker-entrypoint.sh

1. database initialization from `_database_init`
2. PostgreSQL environment variables `POSTGRES_USER`, `POSTGRES_PASSWORD`, `PGPASSWORD`
3. PostgreSQL client command `pg_isready` replacement

### docker-compose.yml

1. Update `database` definition from PostgreSQL to CockroachDB
2. Modify `environment` settings for the `irods` container to use CockroachDB configuration settings.
