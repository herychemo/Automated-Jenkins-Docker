#!/bin/bash

# for credential named 'ssh'
sed -i "s;CREDENTIAL_SSH_PRIVATE_KEY;$(</usr/share/jenkins/ref/.ssh/id_rsa sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n');" /usr/share/jenkins/ref/credentials.xml
