# This Dockerfile was generated from the template at templates/Dockerfile.j2
FROM centos:7
LABEL maintainer "Elastic Docker Team <docker@elastic.co>"
EXPOSE 5601

# Add Reporting dependencies.
RUN yum update -y && yum install -y fontconfig freetype && yum clean all

WORKDIR /usr/share/kibana
RUN curl -Ls https://artifacts.elastic.co/downloads/kibana/kibana-5.6.4-linux-x86_64.tar.gz | tar --strip-components=1 -zxf - && \
    ln -s /usr/share/kibana /opt/kibana

ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/kibana/bin:$PATH

# Set some Kibana configuration defaults.
COPY config/kibana-oss.yml /usr/share/kibana/config/kibana.yml

# Add the launcher/wrapper script. It knows how to interpret environment
# variables and translate them to Kibana CLI options.
COPY bin/kibana-docker /usr/local/bin/

# Add a self-signed SSL certificate for use in examples.
COPY ssl/kibana.example.org.* /usr/share/kibana/config/
RUN chmod -R 0777 /usr/share/kibana


CMD ["/bin/bash", "/usr/local/bin/kibana-docker"]
