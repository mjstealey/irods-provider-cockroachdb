#!/usr/bin/env bash
set -e

### update UID:GID values for irods service account
_update_uid_gid() {
  # update UID
  usermod -u ${UID_IRODS} irods
  # update GID
  groupmod -g ${GID_IRODS} irods
  # update directories
  chown -R irods:irods /var/lib/irods
  chown -R irods:irods /etc/irods
  su - irods -c 'echo "export PGPASSWORD='${IRODS_DATABASE_PASSWORD}'" > .profile'
}

### initialize ICAT database
_database_setup() {
  cat > /init_icat.sql <<EOF
CREATE USER irods WITH PASSWORD '${IRODS_DATABASE_PASSWORD}';
CREATE DATABASE "${IRODS_DATABASE_NAME}";
GRANT ALL PRIVILEGES ON DATABASE "${IRODS_DATABASE_NAME}" TO irods;
EOF
  cat /init_icat.sql
  PGPASSWORD=${POSTGRES_PASSWORD} psql -U ${POSTGRES_USER} -h \
    ${IRODS_DATABASE_SERVER_HOSTNAME} -a -f /init_icat.sql
}

### repopulate contents of /var/lib/irods if external volume mount is used
_irods_tgz() {
  cp /irods.tar.gz /var/lib/irods/irods.tar.gz
  cd /var/lib/irods/
  echo "!!! populating /var/lib/irods with initial contents !!!"
  tar -zxvf irods.tar.gz
  cd /
  rm -f /var/lib/irods/irods.tar.gz
}

### generate iRODS config file
_generate_config() {
    cat > /irods.config <<EOF
${IRODS_SERVICE_ACCOUNT_NAME}
${IRODS_SERVICE_ACCOUNT_GROUP}
${IRODS_SERVER_ROLE}
${ODBC_DRIVER_FOR_POSTGRES}
${IRODS_DATABASE_SERVER_HOSTNAME}
${IRODS_DATABASE_SERVER_PORT}
${IRODS_DATABASE_NAME}
${IRODS_DATABASE_USER_NAME}
yes
${IRODS_DATABASE_PASSWORD}
${IRODS_DATABASE_USER_PASSWORD_SALT}
${IRODS_ZONE_NAME}
${IRODS_PORT}
${IRODS_PORT_RANGE_BEGIN}
${IRODS_PORT_RANGE_END}
${IRODS_CONTROL_PLANE_PORT}
${IRODS_SCHEMA_VALIDATION}
${IRODS_SERVER_ADMINISTRATOR_USER_NAME}
yes
${IRODS_SERVER_ZONE_KEY}
${IRODS_SERVER_NEGOTIATION_KEY}
${IRODS_CONTROL_PLANE_KEY}
${IRODS_SERVER_ADMINISTRATOR_PASSWORD}
${IRODS_VAULT_DIRECTORY}
EOF
}

# tail -f /dev/null

### main ###

### external volume mount will be empty on initial run
if [[ ! -f /var/lib/irods/irodsctl ]]; then
  _irods_tgz
fi

### check for UID:GID change and update directory permissions
_update_uid_gid

### wait for database to stand up
until [ $(pg_isready -h ${IRODS_DATABASE_SERVER_HOSTNAME} -q)$? -eq 0 ]; do
  echo "Postgres is unavailable - sleeping"
  sleep 2
done

### start iRODS
if [[ ! -d /var/lib/irods/iRODS ]]; then
  ### initialize iRODS if being run for the first time
  _database_setup
  _generate_config
  export PGPASSWORD=${IRODS_DATABASE_PASSWORD}
  python /var/lib/irods/scripts/setup_irods.py < /irods.config
  _update_uid_gid
else
  ### restart iRODS if being run after initialization
  until [ $(pg_isready -h ${IRODS_DATABASE_SERVER_HOSTNAME} -q)$? -eq 0 ]; do
    echo "Postgres is unavailable - sleeping"
    sleep 2
  done
  service irods start
fi

### Keep process running forever
tail -f /dev/null

exit 0;
