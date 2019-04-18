
docker run -p 8080:8080 \
    -p 5050:5555 \
    -v //var/run/docker.sock:/var/run/docker.sock  \
    --name localJenkins \
    herychemo/jenkins:latest
