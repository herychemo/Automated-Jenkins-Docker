FROM jenkins/jenkins:lts

# Docker
USER root

RUN apt-get update && apt-get install -y \
    curl \
    dos2unix  \
    socat

RUN curl -sSL https://get.docker.com/ | sh

COPY fix_docker_permission /etc/init.d/fix_docker_permission
RUN dos2unix /etc/init.d/fix_docker_permission
RUN chmod 755 /etc/init.d/fix_docker_permission
RUN usermod -aG docker jenkins

# Clean up apt-get
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER jenkins

# Basic Configuration
ENV JENKINS_SLAVE_AGENT_PORT 5007
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Base dconfiguration
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

ADD credentials.xml /usr/share/jenkins/ref/credentials.xml
ADD id_rsa /usr/share/jenkins/ref/.ssh/id_rsa
ADD id_rsa.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub

ADD jenkins.security.QueueItemAuthenticatorConfiguration.xml /usr/share/jenkins/ref/jenkins.security.QueueItemAuthenticatorConfiguration.xml
ADD job-dsl-seed-1.xml /usr/share/jenkins/ref/jobs/dsl-seed/config.xml

# Plugins
COPY plugins.txt /plugins.txt
RUN /usr/local/bin/install-plugins.sh < /plugins.txt

