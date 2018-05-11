FROM alpine:latest
MAINTAINER newtcv | https://github.com/newtcv

RUN apk update && \
	apk add mysql mysql-client bash && \
	addgroup mysql mysql && \
	mkdir /scripts && \
	rm -rf /var/cache/apk/*

RUN sed -i "s/max_allowed_packet = 16M/max_allowed_packet = 100M/g" /etc/mysql/my.cnf \
    && sed -i "s/max_allowed_packet = 1M/max_allowed_packet = 100M/g" /etc/mysql/my.cnf \
    && sed -i "/myisam_sort_buffer_size = 8M/a wait_timeout = 28800" /etc/mysql/my.cnf \
    && sed -i "/myisam_sort_buffer_size = 8M/a interactive_timeout = 28800" /etc/mysql/my.cnf

VOLUME ["/var/lib/mysql"]

COPY ./startup.sh /scripts/startup.sh
RUN chmod +x /scripts/startup.sh

EXPOSE 3306

ENTRYPOINT ["/scripts/startup.sh"]