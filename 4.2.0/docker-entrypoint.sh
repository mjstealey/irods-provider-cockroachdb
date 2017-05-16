#!/usr/bin/env bash
set -e

IRODS_CONFIG_FILE=/irods.config

_start_db() {
    cockroach start --port=${IRODS_DATABASE_SERVER_PORT} --host=${IRODS_DATABASE_SERVER_HOSTNAME} --insecure
}

_init_icat() {
    > /init-icat.sql
    echo "CREATE USER ${IRODS_DATABASE_USER_NAME} WITH PASSWORD '${IRODS_DATABASE_PASSWORD}';" >> /init-icat.sql
    echo "CREATE DATABASE \"${IRODS_DATABASE_NAME}\";" >> /init-icat.sql
    echo "GRANT ALL ON DATABASE \"${IRODS_DATABASE_NAME}\" TO ${IRODS_DATABASE_USER_NAME};" >> /init-icat.sql
    gosu root cockroach sql --port=${IRODS_DATABASE_SERVER_PORT} --insecure < /init-icat.sql
}

generate_config() {
    echo "${IRODS_SERVICE_ACCOUNT_NAME}" > ${IRODS_CONFIG_FILE}
    echo "${IRODS_SERVICE_ACCOUNT_GROUP}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_SERVER_ROLE}" >> ${IRODS_CONFIG_FILE} # 1. provider, 2. consumer
    echo "${ODBC_DRIVER_FOR_POSTGRES}" >> ${IRODS_CONFIG_FILE} # 1. PostgreSQL ANSI, 2. PostgreSQL Unicode
    echo "${IRODS_DATABASE_SERVER_HOSTNAME}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_DATABASE_SERVER_PORT}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_DATABASE_NAME}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_DATABASE_USER_NAME}" >> ${IRODS_CONFIG_FILE}
    echo "yes" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_DATABASE_PASSWORD}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_DATABASE_USER_PASSWORD_SALT}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_ZONE_NAME}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_PORT}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_PORT_RANGE_BEGIN}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_PORT_RANGE_END}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_CONTROL_PLANE_PORT}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_SCHEMA_VALIDATION}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_SERVER_ADMINISTRATOR_USER_NAME}" >> ${IRODS_CONFIG_FILE}
    echo "yes" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_SERVER_ZONE_KEY}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_SERVER_NEGOTIATION_KEY}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_CONTROL_PLANE_KEY}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_SERVER_ADMINISTRATOR_PASSWORD}" >> ${IRODS_CONFIG_FILE}
    echo "${IRODS_VAULT_DIRECTORY}" >> ${IRODS_CONFIG_FILE}
}

if [[ "$1" = 'setup_irods.py' ]]; then
    _start_db &
    sleep 5s
    _init_icat
    generate_config
    # Keep container alive
    tail -f /dev/null
else
    exec "$@"
fi

exit 0;