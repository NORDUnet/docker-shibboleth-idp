#!/bin/sh -x

# shibboleth-identity-provider source dir
cd /opt/shibboleth-identity-provider-${IDP_VERSION}

case "$*" in
    start)
        # Upgrade/Recreate war
        ./bin/install.sh -Didp.src.dir /opt/shibboleth-identity-provider-${IDP_VERSION}/ -Didp.target.dir /opt/shibboleth-idp
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
