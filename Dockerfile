FROM simpledrupalcloud/node

MAINTAINER Jürgen Viljaste <viljaste@simpledrupalcloud.com>

ENV DEBIAN_FRONTEND noninteractive

ADD ./build /tmp/build

RUN chmod +x /tmp/build/build.sh
RUN /tmp/build/build.sh
RUN rm -rf /tmp/*

ENTRYPOINT ["/run.sh"]