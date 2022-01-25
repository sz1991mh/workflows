FROM node:lts-alpine AS builder

RUN set -ex; \
        apk add --no-cache jq ;\
        cd /opt; npm init surgio-store my-rule-store; \
        cd /opt/my-rule-store; npm install @surgio/gateway; \
        : ;
        
COPY gateway.js /opt/my-rule-store/



FROM node:lts-alpine

ENV SURGIO_VERSION 2.14.2

COPY --from=builder /opt/my-rule-store /opt/surgio
COPY docker-entrypoint.sh /usr/local/bin/

VOLUME /etc/surgio

ENTRYPOINT [ "docker-entrypoint.sh" ]

WORKDIR /etc/surgio
EXPOSE 3000

CMD [ "/opt/surgio/gateway.js" ]
