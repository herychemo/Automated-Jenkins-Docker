FROM jenkins/jenkins:lts

ENV JENKINS_SLAVE_AGENT_PORT 5007
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

ADD credentials.xml /usr/share/jenkins/ref/credentials.xml
ADD id_rsa /usr/share/jenkins/ref/.ssh/id_rsa
ADD id_rsa.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub

ADD jenkins.security.QueueItemAuthenticatorConfiguration.xml /usr/share/jenkins/ref/jenkins.security.QueueItemAuthenticatorConfiguration.xml
ADD job-dsl-seed-1.xml /usr/share/jenkins/ref/jobs/dsl-seed/config.xml

COPY plugins.txt /plugins.txt
RUN /usr/local/bin/install-plugins.sh < /plugins.txt

