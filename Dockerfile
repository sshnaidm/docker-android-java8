FROM sshnaidm/java8:latest

LABEL maintainer "sshnaidm <einarum@gmail.com>"
LABEL description "Android SDK image, based on Alpine Linux with Oracle Java 8"
LABEL customize "Add your packages to ANDROID_INSTALL line below"

# Versions
ENV ANDROID_BUILD_TOOLS_VERSION 25.2.3
# Install with sdkmanager:
ENV ANDROID_INSTALL platform-tools
ENV ANDROID_INSTALL $ANDROID_INSTALL platforms;android-25
ENV ANDROID_INSTALL $ANDROID_INSTALL build-tools;25.0.2
ENV ANDROID_INSTALL $ANDROID_INSTALL extras;android;m2repository
ENV ANDROID_INSTALL $ANDROID_INSTALL extras;google;m2repository
# Environment variables
ENV ANDROID_TOOLS_URL https://dl.google.com/android/repository/tools_r${ANDROID_BUILD_TOOLS_VERSION}-linux.zip
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_TOOLS_HOME /opt/android-sdk/tools
ENV PATH ${PATH}:${ANDROID_TOOLS_HOME}:${ANDROID_TOOLS_HOME}/bin:${ANDROID_HOME}/platform-tools

RUN apk update && \
    apk add bash ca-certificates wget openssl && \
    update-ca-certificates
RUN mkdir -p /opt/android-sdk && cd /opt/android-sdk && \
    wget -q $ANDROID_TOOLS_URL && \
    unzip -q tools_r${ANDROID_BUILD_TOOLS_VERSION}-linux.zip && \
    rm -f tools_r${ANDROID_BUILD_TOOLS_VERSION}-linux.zip && \
    mkdir -p /root/.android/ && touch /root/.android/repositories.cfg && \
    echo "Installing $ANDROID_INSTALL" && \
    yes | sdkmanager --update && \
    yes | sdkmanager --licenses && \
    for i in $ANDROID_INSTALL; do yes | sdkmanager $i ; done && \
    rm /var/cache/apk/* && \
    sdkmanager --list --verbose && java -version

