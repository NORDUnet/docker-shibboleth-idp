#
# SSL Keystore module
#

[depend]
server

[xml]
etc/jetty-ssl.xml

[files]
/opt/shibboleth-idp/credentials/idp-browser.p12

[ini-template]
### SSL Keystore Configuration
# define the port to use for secure redirection
jetty.secure.port=8443

## Setup a keystore
jetty.keystore=/opt/shibboleth-idp/credentials/idp-browser.p12
jetty.keystore.type=PKCS12

## Set the demonstration passwords.
## Note that OBF passwords are not secure, just protected from casual observation
## See http://www.eclipse.org/jetty/documentation/current/configuring-security-secure-passwords.html
jetty.keystore.password=

### Set the client auth behavior
## Set to true if client certificate authentication is required
# jetty.ssl.needClientAuth=true
## Set to true if client certificate authentication is desired
# jetty.ssl.wantClientAuth=true

## Parameters to control the number and priority of acceptors and selectors
# ssl.selectors=1
# ssl.acceptors=1
# ssl.selectorPriorityDelta=0
# ssl.acceptorPriorityDelta=0
