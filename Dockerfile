FROM alpine:latest

# install sqlite, curl, bash (for script)
RUN apk add --no-cache \
    sqlite \
    curl \
    bash \
    openssl

# install dropbox uploader script
RUN curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh && \
    chmod +x dropbox_uploader.sh

# copy backup script to /
COPY backup.sh /

# copy entrypoint to /
COPY entrypoint.sh /

# copy delete older backup script to /
COPY deleteold.sh /

# give execution permission to scripts
RUN chmod +x /entrypoint.sh && \
    chmod +x /backup.sh && \
    chmod +x /deleteold.sh

RUN echo "0 1 * * * /backup.sh" > /etc/crontabs/root

ENTRYPOINT ["/entrypoint.sh"]
