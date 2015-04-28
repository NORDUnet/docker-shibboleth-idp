FROM dockerfile/java:oracle-java7
MAINTAINER Johan Lundberg <lundberg@nordu.net>

# Install packages
RUN apt-get update && \ 
    apt-get update --fix-missing && \ 
    apt-get install -y wget

# Add UnlimitedJCEPolicy
# You manually have to download and unzip jce_policy-8.zip from Oracle,
# http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html
ADD UnlimitedJCEPolicyJDK8/local_policy.jar ${JAVA_HOME}/jre/lib/security/
ADD UnlimitedJCEPolicyJDK8/US_export_policy.jar ${JAVA_HOME}/jre/lib/security/

# Download and install jetty
ENV JETTY_VERSION 9.2.10
ENV RELEASE_DATE v20150310
RUN wget http://download.eclipse.org/jetty/stable-9/dist/jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}.tar.gz && \
    tar -xzvf jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}.tar.gz && \
    rm -rf jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}.tar.gz && \
    mv jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}/ /opt/jetty

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
ENV IDP_VERSION 3.0.0
RUN wget https://shibboleth.net/downloads/identity-provider/${IDP_VERSION}/shibboleth-identity-provider-${IDP_VERSION}.tar.gz && \
    tar -xzvf shibboleth-identity-provider-${IDP_VERSION}.tar.gz && \
    rm -rf shibboleth-identity-provider-${IDP_VERSION}.tar.gz && \
    mv shibboleth-identity-provider-${IDP_VERSION} /opt/shibboleth-identity-provider-${IDP_VERSION}

ADD start.sh /start.sh
RUN chmod a+x /start.sh
# Set defaults for docker run
ENTRYPOINT ["/start.sh"]
CMD ["start"]
