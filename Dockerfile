FROM java:8
MAINTAINER Markus Krogh <markus@nordu.net>

# Install packages
RUN apt-get update && \ 
    apt-get update --fix-missing && \ 
    apt-get install -y wget

# UnlimitedJCEPolicy - OpenJDK includes JCE
# If not manually have to download and unzip jce_policy-8.zip from Oracle,
# http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html

# Download and install jetty
ENV JETTY_VERSION 9.3.13.v20161014
RUN wget https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${JETTY_VERSION}/jetty-distribution-${JETTY_VERSION}.tar.gz && \
    tar xf jetty-distribution-${JETTY_VERSION}.tar.gz && \
    rm -rf jetty-distribution-${JETTY_VERSION}.tar.gz && \
    mv jetty-distribution-${JETTY_VERSION}/ /opt/jetty

# Configure Jetty user and clean up install
RUN useradd jetty && \
    chown -R jetty:jetty /opt/jetty && \
    rm -rf /opt/jetty/webapps.demo

# Add configuration files
ADD jetty_conf /jetty_conf
RUN mv /jetty_conf/start.ini /opt/jetty/start.ini && \
    mv /jetty_conf/jetty-ssl.xml /opt/jetty/etc/jetty-ssl.xml && \
    mv /jetty_conf/jetty-https.xml /opt/jetty/etc/jetty-https.xml && \
    mv /jetty_conf/ssl.mod /opt/jetty/modules/ssl.mod && \
    mv /jetty_conf/idp.xml /opt/jetty/webapps/idp.xml

# Download shibboleth-idp
ENV IDP_VERSION 3.2.1
RUN wget https://shibboleth.net/downloads/identity-provider/${IDP_VERSION}/shibboleth-identity-provider-${IDP_VERSION}.tar.gz && \
    tar -xzvf shibboleth-identity-provider-${IDP_VERSION}.tar.gz && \
    rm -rf shibboleth-identity-provider-${IDP_VERSION}.tar.gz && \
    mv shibboleth-identity-provider-${IDP_VERSION} /opt/shibboleth-identity-provider-${IDP_VERSION}

ADD start.sh /start.sh
RUN chmod a+x /start.sh
# Set defaults for docker run
ENTRYPOINT ["/start.sh"]
CMD ["start"]
