#
# To build:
# > docker build -t scrapyrt -f Dockerfile .
#
# to start as daemon with port 9080 of api exposed as 9080 on host
# and host's directory ${PROJECT_DIR} mounted as /scrapyrt/project
#
# > docker run -p 9080:9080 -tid -v ${PROJECT_DIR}:/scrapyrt/project scrapyrt
#
#
# docker tag scrapyrt dockgw20e/scrapyrt:latest
# docker push dockgw20e/scrapyrt:latest
#
FROM python:3.6-stretch

ENV DEBIAN_FRONTEND noninteractive

# Install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y libglib2.0-0=2.50.3-2 \
    libnss3=2:3.26.2-1.1+deb9u1 \
    libgconf-2-4=3.2.6-4+b1 \
    libfontconfig1=2.11.0-6.7+b1
RUN apt-get install -y google-chrome-stable
RUN apt-get install -y mc

# Install chrome driver
RUN wget -N http://chromedriver.storage.googleapis.com/2.42/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN chmod +x chromedriver
RUN mv -f chromedriver /usr/local/share/chromedriver
RUN ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
RUN ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

RUN mkdir -p /scrapyrt/src /scrapyrt/project
RUN mkdir -p /var/log/scrapyrt


ADD . /scrapyrt/src
RUN pip install /scrapyrt/src

WORKDIR /scrapyrt/project

ENTRYPOINT ["scrapyrt", "-i", "0.0.0.0"]

EXPOSE 9080
