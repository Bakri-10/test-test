    libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 numactl procps zlib1g

# Bitnami specific commands
# Note: Check the compatibility of the components with Ubuntu.
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "yq-4.40.5-3-linux-${OS_ARCH}-debian-11" \
      "wait-for-port-1.0.7-7-linux-${OS_ARCH}-debian-11" \
      "render-template-1.0.6-7-linux-${OS_ARCH}-debian-11" \
      "mongodb-shell-2.1.3-0-linux-${OS_ARCH}-debian-11" \
      "mongodb-7.0.5-3-linux-${OS_ARCH}-debian-11" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done

# Cleaning up
RUN apt-get purge -y --auto-remove curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# File permissions and other configurations
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY rootfs /
# Set the execute permission for necessary scripts
RUN chmod +x /opt/bitnami/scripts/mongodb/postunpack.sh && \
    chmod +x /opt/bitnami/scripts/mongodb/entrypoint.sh && \
    chmod +x /opt/bitnami/scripts/mongodb/setup.sh && \
    chmod +x /opt/bitnami/scripts/mongodb/*.sh  # This line sets execute permission for all .sh files
# Execute the postunpack.sh script
RUN /opt/bitnami/scripts/mongodb/postunpack.sh

ENV APP_VERSION="7.0.5" \
    BITNAMI_APP_NAME="mongodb" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mongodb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mongodb/run.sh" ]
                                                                                    78,45         Bot 
