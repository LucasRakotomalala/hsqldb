FROM --platform=linux/x86_64 openjdk:8

ENV HSQLDB_VERSION=2.3.1 \
    JAVA_VM_PARAMETERS= \
    HSQLDB_TRACE= \
    HSQLDB_SILENT= \
    HSQLDB_REMOTE= \
    HSQLDB_DATABASE_NAME= \
    HSQLDB_DATABASE_ALIAS= \
    HSQLDB_DATABASE_HOST= \
    HSQLDB_USER= \
    HSQLDB_PASSWORD=

RUN apt-get update && \
    apt-get install \
      ca-certificates \
      wget && \
    mkdir -p /opt/database && \
    mkdir -p /opt/hsqldb && \
    mkdir -p /scripts

COPY entrypoint.sh /opt/hsqldb/entrypoint.sh

RUN wget -O /opt/hsqldb/hsqldb.jar https://repo1.maven.org/maven2/org/hsqldb/hsqldb/${HSQLDB_VERSION}/hsqldb-${HSQLDB_VERSION}.jar && \
    wget -O /opt/hsqldb/sqltool.jar https://repo1.maven.org/maven2/org/hsqldb/sqltool/${HSQLDB_VERSION}/sqltool-${HSQLDB_VERSION}.jar && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    # Clean caches and tmps
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/log/*

VOLUME ["/opt/database"]

EXPOSE 9001

ENTRYPOINT ["/opt/hsqldb/entrypoint.sh"]

CMD ["hsqldb"]