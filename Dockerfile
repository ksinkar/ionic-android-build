FROM fedora:27

ENV ANDROID_HOME=/opt/google/android-tools-sdk \
    JAVA_HOME=/usr/lib/jvm/java-openjdk \
    GRADLE_HOME=/opt/gradle \
    GRADLE_VERSION=4.6  \
    PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/platform-tools/bin:$GRADLE_HOME/gradle-4.6/bin

RUN dnf upgrade --assumeyes && \
    dnf install --assumeyes wget curl zip unzip \
                            @development-tools \
                            nodejs java-1.8.0-openjdk-devel

RUN dnf install --assumeyes zlib.i686 ncurses-libs.i686 bzip2-libs.i686

# Install Android Tools
ENV SDK_TARGET=sdk-tools-linux-3859397
RUN mkdir -p $ANDROID_HOME && \
    wget --no-verbose https://dl.google.com/android/repository/$SDK_TARGET.zip && \
    unzip -d $ANDROID_HOME $SDK_TARGET.zip  && \
    rm -f $SDK_TARGET.zip 

# Install Gradle
RUN mkdir -p $GRADLE_HOME && \
    wget --no-verbose https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
    unzip -d $GRADLE_HOME gradle-$GRADLE_VERSION-bin.zip && \
    rm -f gradle-$GRADLE_VERSION-bin.zip 

# Install Android SDK   
RUN yes Y | ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;25.0.2" "platforms;android-25" "platform-tools"

# Install Ionic and Cordova
RUN npm install --global cordova ionic
