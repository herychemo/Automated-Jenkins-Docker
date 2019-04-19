#!/bin/bash

# for credential named 'git-ssh'
sed -i "s;CREDENTIAL_GIT_SSH_PRIVATE_KEY;$(</usr/share/jenkins/ref/.ssh/id_rsa sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n');" /usr/share/jenkins/ref/credentials.xml
