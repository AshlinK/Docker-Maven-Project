#Dockerfile to build an image which supports execution of Maven Project.
FROM ubuntu
MAINTAINER Ashlin Karkada

ENV FIREFOX_VERSION 45.0.2
ENV CHROMEDRIVER_VERSION 78.0.3904.105
ENV MAVEN_VERSION 3.0.5
 
# Essential tools and xvfb

WORKDIR /bin
RUN apt-get update && apt-get install -y \
    software-properties-common \
    unzip \
    curl \
    xvfb 
	
RUN apt-get install -y openjdk-8-jdk \
	&& which java \
	&& java -version
 
#Install Chrome browser to run the tests
RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub -o /tmp/google.pub \
    && cat /tmp/google.pub | apt-key add -; rm /tmp/google.pub \
    && echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google.list \
    && mkdir -p /usr/share/desktop-directories \
    && apt-get -y update && apt-get install -y google-chrome-stable
# Disable the SUID sandbox so that chrome can launch without being in a privileged container

RUN dpkg-divert --add --rename --divert /opt/google/chrome/google-chrome.real /opt/google/chrome/google-chrome \
    && echo "#!/bin/bash\nexec /opt/google/chrome/google-chrome.real --no-sandbox --disable-setuid-sandbox \"\$@\"" > /opt/google/chrome/google-chrome \
    && chmod 755 /opt/google/chrome/google-chrome \
	&& google-chrome --version
	

RUN FIREFOX_DOWNLOAD_URL=$(if [ $FIREFOX_VERSION = "latest" ] || [ $FIREFOX_VERSION = "nightly-latest" ] || [ $FIREFOX_VERSION = "devedition-latest" ]; then echo "https://download.mozilla.org/?product=firefox-$FIREFOX_VERSION-ssl&os=linux64&lang=en-US"; else echo "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2"; fi) \
  && apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install firefox \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
  && wget --no-verbose -O /tmp/firefox.tar.bz2 $FIREFOX_DOWNLOAD_URL \
  && apt-get -y purge firefox \
  && rm -rf /opt/firefox \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
  && ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox


# Install Maven , extract it ,set it's path and remove the .gz file
RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
	&& tar -xvzf apache-maven-$MAVEN_VERSION-bin.tar.gz \
	&& export PATH=/bin/apache-maven-$MAVEN_VERSION/bin:$PATH \
	&& rm apache-maven-$MAVEN_VERSION-bin.tar.gz \
	&& mvn -version
	
#Install Nano Editor
RUN apt update \
    && apt install nano \
	&& nano --version
	
	
#Install ChromeDriver
RUN wget "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" \
    && apt-get install unzip \
	&& unzip chromedriver_linux64.zip \
	&& chromedriver -version \
	&& rm chromedriver_linux64.zip
	

# Create a directory
RUN mkdir -p /dir/subdir/MavenDockerProject

# Copy the project files
COPY . /usr/dir/subdir/MavenDockerProject

# Move chromedriver to project resources folder
RUN mv /bin/chromedriver /usr/dir/subdir/MavenDockerProject/resources
WORKDIR /usr/dir/subdir/MavenDockerProject/resources
RUN ls -a

	
WORKDIR /usr/dir/subdir/MavenDockerProject

RUN echo "$PWD"
RUN ls -a


# Enable and set the display server
RUN export DISPLAY=:20 \
	&& echo $DISPLAY \
	&& Xvfb :20 -screen 0 1366x768x16 &
	
	
# Set the startup command to run your binary
#ENTRYPOINT ["mvn","clean","install","test","-Dtest=LoginTest"]
