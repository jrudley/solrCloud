# Builds Solr image for a Windows container environment
#docker build --build-arg openJdkVersion=8u252-jre-windowsservercore-1809 --build-arg solrVersion=8.1.1 . -t solr:811
#https://hub.docker.com/r/winamd64/openjdk/
ARG openJdkVersion='8-jre-windowsservercore-1809'

FROM openjdk:$openJdkVersion

LABEL maintainer="James Rudley"

SHELL ["powershell", "-NoProfile", "-Command", "$ErrorActionPreference = 'Stop';"]

ARG solrVersion

RUN Invoke-WebRequest -verbose -UseBasicParsing -Method Get -Uri "http://archive.apache.org/dist/lucene/solr/$($env:solrVersion)/solr-$($env:solrVersion).zip"  -OutFile solr.zip ; \
    Expand-Archive -Path solr.zip -DestinationPath c:/solr ; \
    Remove-Item solr.zip -Force

WORKDIR /solr/solr-$solrVersion

EXPOSE 8983

ENTRYPOINT bin/solr start -port 8983 -f -c -noprompt
