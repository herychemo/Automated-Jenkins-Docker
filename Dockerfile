FROM jenkins/jenkins:lts


# Basic Configuration
ENV JENKINS_SLAVE_AGENT_PORT 5007
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"


# Install base packages
USER root

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y \
    curl \
    dos2unix  \
    socat


# Install Docker client
RUN curl -sSL https://get.docker.com/ | sh

# Setup Docker permissions stuff
COPY /conf/scripts/fix_docker_permission /usr/local/bin/fix_docker_permission
RUN dos2unix /usr/local/bin/fix_docker_permission


# Add jenkins user to docker group
RUN usermod -aG docker jenkins


# Clean-up apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER jenkins



#   Base dconfiguration

# Login Admin user
COPY /conf/groovy/security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy

# Executors
COPY /conf/groovy/executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy


# Credentials
ADD /conf/credentials.xml /usr/share/jenkins/ref/credentials.xml

# for 'git-ssh'
ADD /conf/ssh_keys/git-ssh/id_rsa /usr/share/jenkins/ref/.ssh/id_rsa
ADD /conf/ssh_keys/git-ssh/id_rsa.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub

# for 'java-worker-ssh'
ADD /conf/ssh_keys/java-worker-ssh/id_rsa /usr/share/jenkins/ref/.ssh/id_rsa_java_worker
ADD /conf/ssh_keys/java-worker-ssh/id_rsa.pub /usr/share/jenkins/ref/.ssh/id_rsa_java_worker.pub


COPY /conf/scripts/update_ssh_credentials.sh /usr/local/bin/update_ssh_credentials.sh

USER root
RUN dos2unix /usr/local/bin/update_ssh_credentials.sh

USER jenkins
RUN /bin/bash /usr/local/bin/update_ssh_credentials.sh


# Job Authentication
ADD /conf/jenkins.security.QueueItemAuthenticatorConfiguration.xml /usr/share/jenkins/ref/jenkins.security.QueueItemAuthenticatorConfiguration.xml


# Add DSL Base job
ADD /conf/jobs/job-dsl-seed-1.xml /usr/share/jenkins/ref/jobs/dsl-seed/config.xml


# Custom Entry Point
USER root
COPY /conf/scripts/custom_entrypoint.sh /usr/local/bin/custom_entrypoint.sh
RUN dos2unix /usr/local/bin/custom_entrypoint.sh
USER jenkins

# Define custom Entry point
ENTRYPOINT ["/bin/bash", "/usr/local/bin/custom_entrypoint.sh"]


# Install Plugins
COPY /conf/plugins.txt /plugins.txt
RUN /usr/local/bin/install-plugins.sh < /plugins.txt

# Use default root user for entry point
USER root
