FROM alpine
RUN apk add openssh openssh-server
COPY entrypoint.sh /
ENV T_REMOTE=localhost:80
ENV T_USER=root@localhost
ENV T_PORT=8022
ENTRYPOINT ["sh", "/entrypoint.sh"]
