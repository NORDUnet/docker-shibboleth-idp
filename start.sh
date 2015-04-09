#!/bin/sh -x

# shibboleth-identity-provider source dir
cd /opt/shibboleth-identity-provider-${IDP_VERSION}

case "$*" in
    start)
        # Upgrade/Recreate war
        ./bin/install.sh -Didp.src.dir /opt/shibboleth-identity-provider-${IDP_VERSION}/ -Didp.target.dir /opt/shibboleth-idp
	# Set Jetty tls cert password
	sed -i "/jetty.keystore.password=/c\jetty.keystore.password=$PKCS12_PASSWORD" /opt/jetty/modules/ssl.mod
	# Start Jetty
	cd /opt/jetty/ && /usr/bin/java -jar start.jar
    ;;
    install)
        # Fresh install
cat>/tmp/entity_id<<EOF
idp.entityID= ${ENTITY_ID}
EOF
        ./bin/install.sh -Didp.src.dir /opt/shibboleth-identity-provider-${IDP_VERSION}/ -Didp.target.dir /opt/shibboleth-idp -Didp.host.name ${HOSTNAME} -Didp.scope ${SCOPE} -Didp.sealer.password ${COOKIE_PASSWORD} -Didp.keystore.password ${TLS_PASSWORD} -Didp.merge.properties /tmp/entity_id -Didp.noprompt
    ;;
    debug)
        /bin/bash
    ;;
esac
