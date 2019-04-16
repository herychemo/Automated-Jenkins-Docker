#!/usr/bin/env bash

/bin/bash /usr/local/bin/fix_docker_permission



# once root processes are done, go back to jenkins user
su - jenkins

# Original entry point
/sbin/tini -- /usr/local/bin/jenkins.sh
