# irods-provider-cockroachdb
iRODS provider using CockroachDB as ICAT backend in Docker

**WORK IN PROGRESS**

Currently makes use of a PostgreSQL database as a placeholder for CockroachDB.

## Usage

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
                                                    20014/tcp, 20015/tcp, 20016/tcp, 20017/tcp, 20018/tcp, 20019/tcp, 20020/tcp, 20021/tcp,
                                                    20022/tcp, 20023/tcp, 20024/tcp, 20025/tcp, 20026/tcp, 20027/tcp, 20028/tcp, 20029/tcp,
                                                    20030/tcp, 20031/tcp, 20032/tcp, 20033/tcp, 20034/tcp, 20035/tcp, 20036/tcp, 20037/tcp,
                                                    20038/tcp, 20039/tcp, 20040/tcp, 20041/tcp, 20042/tcp, 20043/tcp, 20044/tcp, 20045/tcp,
                                                    20046/tcp, 20047/tcp, 20048/tcp, 20049/tcp, 20050/tcp, 20051/tcp, 20052/tcp, 20053/tcp,
                                                    20054/tcp, 20055/tcp, 20056/tcp, 20057/tcp, 20058/tcp, 20059/tcp, 20060/tcp, 20061/tcp,
                                                    20062/tcp, 20063/tcp, 20064/tcp, 20065/tcp, 20066/tcp, 20067/tcp, 20068/tcp, 20069/tcp,
                                                    20070/tcp, 20071/tcp, 20072/tcp, 20073/tcp, 20074/tcp, 20075/tcp, 20076/tcp, 20077/tcp,
                                                    20078/tcp, 20079/tcp, 20080/tcp, 20081/tcp, 20082/tcp, 20083/tcp, 20084/tcp, 20085/tcp,
                                                    20086/tcp, 20087/tcp, 20088/tcp, 20089/tcp, 20090/tcp, 20091/tcp, 20092/tcp, 20093/tcp,
                                                    20094/tcp, 20095/tcp, 20096/tcp, 20097/tcp, 20098/tcp, 20099/tcp, 20100/tcp, 20101/tcp,
                                                    20102/tcp, 20103/tcp, 20104/tcp, 20105/tcp, 20106/tcp, 20107/tcp, 20108/tcp, 20109/tcp,
                                                    20110/tcp, 20111/tcp, 20112/tcp, 20113/tcp, 20114/tcp, 20115/tcp, 20116/tcp, 20117/tcp,
                                                    20118/tcp, 20119/tcp, 20120/tcp, 20121/tcp, 20122/tcp, 20123/tcp, 20124/tcp, 20125/tcp,
                                                    20126/tcp, 20127/tcp, 20128/tcp, 20129/tcp, 20130/tcp, 20131/tcp, 20132/tcp, 20133/tcp,
                                                    20134/tcp, 20135/tcp, 20136/tcp, 20137/tcp, 20138/tcp, 20139/tcp, 20140/tcp, 20141/tcp,
                                                    20142/tcp, 20143/tcp, 20144/tcp, 20145/tcp, 20146/tcp, 20147/tcp, 20148/tcp, 20149/tcp,
                                                    20150/tcp, 20151/tcp, 20152/tcp, 20153/tcp, 20154/tcp, 20155/tcp, 20156/tcp, 20157/tcp,
                                                    20158/tcp, 20159/tcp, 20160/tcp, 20161/tcp, 20162/tcp, 20163/tcp, 20164/tcp, 20165/tcp,
                                                    20166/tcp, 20167/tcp, 20168/tcp, 20169/tcp, 20170/tcp, 20171/tcp, 20172/tcp, 20173/tcp,
                                                    20174/tcp, 20175/tcp, 20176/tcp, 20177/tcp, 20178/tcp, 20179/tcp, 20180/tcp, 20181/tcp,
                                                    20182/tcp, 20183/tcp, 20184/tcp, 20185/tcp, 20186/tcp, 20187/tcp, 20188/tcp, 20189/tcp,
                                                    20190/tcp, 20191/tcp, 20192/tcp, 20193/tcp, 20194/tcp, 20195/tcp, 20196/tcp, 20197/tcp,
                                                    20198/tcp, 20199/tcp
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
