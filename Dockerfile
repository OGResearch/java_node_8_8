FROM node:8-alpine
LABEL maintainer "Frantisek Simorda <frantisek.simorda@ogresearch.com>"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

RUN set -x \
	&& apk add --no-cache \
		openjdk8 \
		python2 \
		alpine-sdk \
		autoconf \
		nasm \
		libc6-compat \
		libtool \
		automake \
		bash \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ] \
	&& npm i -g bower

RUN bash -c "sed -i 's/\/bin\/ash/\/bin\/bash/' /etc/passwd"
