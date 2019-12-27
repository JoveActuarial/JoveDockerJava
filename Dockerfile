FROM jupyter/datascience-notebook:1386e2046833

USER root

# Install OpenJDK-11
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

RUN apt-get update \
    && apt-get -y install maven \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /.opengamma \
    && cd /.opengamma \
    && git clone https://github.com/OpenGamma/Strata.git \
    && cd Strata \
    && mvn install

RUN pip install py4j

RUN mkdir /.opengamma/commandlinetool \
    && cd /.opengamma/commandlinetool \
    && wget https://github.com/OpenGamma/Strata/releases/download/v2.6.9/strata-report-tool-2.6.9.zip -q -O download.zip \
    && unzip download.zip \
    && rm -f download.zip
