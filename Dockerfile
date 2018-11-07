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

RUN mkdir -p /scrapyrt/src /scrapyrt/project
RUN mkdir -p /var/log/scrapyrt

ADD . /scrapyrt/src
RUN pip install /scrapyrt/src

WORKDIR /scrapyrt/project

ENTRYPOINT ["scrapyrt", "-i", "0.0.0.0"]

EXPOSE 9080
