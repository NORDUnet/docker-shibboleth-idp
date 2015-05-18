#!/bin/sh -x
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

# shibboleth-identity-provider source dir
cd /opt/shibboleth-identity-provider-${IDP_VERSION}

case "$*" in
    start)
        # Start/Recreate war
        mkdir -p /opt/shibboleth-idp/war
        ./bin/install.sh -Didp.src.dir /opt/shibboleth-identity-provider-${IDP_VERSION}/ -Didp.target.dir /opt/shibboleth-idp
	# Set Jetty tls cert password
	sed -i "/jetty.keystore.password=/c\jetty.keystore.password=$JETTY_TLS_PASSWORD" /opt/jetty/modules/ssl.mod
	# Start Jetty
	cd /opt/jetty/ && /usr/bin/java -jar start.jar
    ;;
    install)
        # Fresh install/upgrade
        cat>/tmp/entity_id<<EOF
idp.entityID= ${ENTITY_ID}
EOF
        mkdir -p /opt/shibboleth-idp/war
        ./bin/install.sh -Didp.src.dir /opt/shibboleth-identity-provider-${IDP_VERSION}/ -Didp.target.dir /opt/shibboleth-idp -Didp.host.name ${HOSTNAME} -Didp.scope ${SCOPE} -Didp.sealer.password ${COOKIE_PASSWORD} -Didp.keystore.password ${IDP_TLS_PASSWORD} -Didp.merge.properties /tmp/entity_id -Didp.noprompt
        # Set sealer password
        sed -i "/idp.sealer.storePassword= password/c\idp.sealer.storePassword= $COOKIE_PASSWORD" /opt/shibboleth-idp/conf/idp.properties
        sed -i "/idp.sealer.keyPassword= password/c\idp.sealer.keyPassword= $COOKIE_PASSWORD" /opt/shibboleth-idp/conf/idp.properties
        # Set scope
        sed -i "/idp.scope= example.org/c\idp.scope= ${SCOPE}" /opt/shibboleth-idp/conf/idp.properties
    ;;
    debug)
        /bin/bash
    ;;
esac
