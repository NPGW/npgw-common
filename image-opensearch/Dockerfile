FROM opensearchproject/opensearch:latest

ENV OPENSEARCH_INITIAL_ADMIN_PASSWORD=${OPENSEARCH_PASSWORD}

COPY opensearch.yml /usr/share/opensearch/config/opensearch.yml
COPY setup-opensearch.sh /usr/local/bin/setup-opensearch.sh

COPY transforms-job.json /usr/local/bin/transforms-job.json
COPY initial-document.json /usr/local/bin/initial-document.json
COPY mapping_properties_status_history.json /usr/local/bin/mapping_properties_status_history.json
COPY mapping_properties_summary.json /usr/local/bin/mapping_properties_summary.json


USER root
RUN chmod +x /usr/local/bin/setup-opensearch.sh
USER opensearch

HEALTHCHECK --interval=20s --timeout=20s --start-period=20s --retries=5 \
  CMD curl -k "${OPENSEARCH_HOST}/${OPENSEARCH_HEALTH_CHECK}" || exit 1

ENTRYPOINT ["/usr/local/bin/setup-opensearch.sh"]
