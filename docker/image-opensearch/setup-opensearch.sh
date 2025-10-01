#!/bin/bash
set -e

HISTORY_INDEX="npgw.transaction.log"
STATUS_INDEX="npgw.transaction.status"
SUMMARY_INDEX="npgw.transaction.summary"
DELTA_INDEX="npgw.transaction.delta"

TRANSFORMS_JOB_NAME="daily_aggregation"
INGEST_PIPELINE_NAME="integer_conversion_pipeline"

MAPPING_PROPERTIES_STATUS_HISTORY="/usr/local/bin/mapping_properties_status_history.json"
MAPPING_PROPERTIES_SUMMARY="/usr/local/bin/mapping_properties_summary.json"
MAPPING_PROPERTIES_DELTA="/usr/local/bin/mapping_properties_delta.json"
TRANSFORMS_JOB="/usr/local/bin/transforms-job.json"
INITIAL_DOCUMENT="/usr/local/bin/initial-document.json"

/usr/share/opensearch/opensearch-docker-entrypoint.sh &

echo "Waiting for OpenSearch to be ready..."
until curl -s -k "${OPENSEARCH_HOST}/${OPENSEARCH_HEALTH_CHECK}" > /dev/null; do
  sleep 5
done

echo "Cluster is up. Waiting for security plugin to be initialized..."
until ! curl -s -k "${OPENSEARCH_HOST}/_plugins/_transform" -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD} | grep -q "not initialized"; do
  echo "Security plugin not yet initialized, waiting..."
  sleep 5
done

echo "OpenSearch is up. Checking if history index '${HISTORY_INDEX}' exists..."
if curl -s -k "${OPENSEARCH_HOST}/${HISTORY_INDEX}" -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD} | grep -q '"index_not_found_exception"'; then
  echo "Source index '${HISTORY_INDEX}' does not exist. Creating it..."
  curl -X PUT "${OPENSEARCH_HOST}/${HISTORY_INDEX}" \
    -k -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD} \
    -H 'Content-Type: application/json' \
    --data-binary @"${MAPPING_PROPERTIES_STATUS_HISTORY}"
fi

echo "Creating status index '${STATUS_INDEX}'..."
if curl -s -k "${OPENSEARCH_HOST}/${STATUS_INDEX}" -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD} | grep -q '"index_not_found_exception"'; then
  echo "Status index '${STATUS_INDEX}' does not exist. Creating it..."
  curl -X PUT "${OPENSEARCH_HOST}/${STATUS_INDEX}" \
    -k -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD} \
    -H 'Content-Type: application/json' \
    --data-binary @"${MAPPING_PROPERTIES_STATUS_HISTORY}"
fi

echo "Creating delta index '${DELTA_INDEX}'..."
if curl -s -k "${OPENSEARCH_HOST}/${DELTA_INDEX}" -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD} | grep -q '"index_not_found_exception"'; then
  echo "Delta index '${DELTA_INDEX}' does not exist. Creating it..."
  curl -X PUT "${OPENSEARCH_HOST}/${DELTA_INDEX}" \
    -k -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD} \
    -H 'Content-Type: application/json' \
    --data-binary @"${MAPPING_PROPERTIES_DELTA}"
fi

echo "Indexing document into '${DELTA_INDEX}'..."
init_doc_output=$(
  curl -X POST "${OPENSEARCH_HOST}/${DELTA_INDEX}/_doc/id.transaction.dummy?refresh=true" \
  -H 'Content-Type: application/json' \
  --data-binary @"${INITIAL_DOCUMENT}" -k -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD}
)
echo "Document index result:"
echo $init_doc_output

echo "Checking if target index '${SUMMARY_INDEX}' exists..."
if curl -s -k "${OPENSEARCH_HOST}/${SUMMARY_INDEX}" -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD} | grep -q '"index_not_found_exception"'; then
  echo "Source index '${SUMMARY_INDEX}' does not exist. Creating it..."
  curl -X PUT "${OPENSEARCH_HOST}/${SUMMARY_INDEX}" \
    -k -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD} \
    -H 'Content-Type: application/json' \
    --data-binary @"${MAPPING_PROPERTIES_SUMMARY}"
fi

echo "Creating ingestion pipeline '${INGEST_PIPELINE_NAME}'..."
curl -X PUT "${OPENSEARCH_HOST}/_ingest/pipeline/${INGEST_PIPELINE_NAME}" \
  -k -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD} \
  -H 'Content-Type: application/json' \
  -d '{
    "description": "Convert totalAmount and totalCount from float to integer",
    "processors": [
      {
        "script": {
          "lang": "painless",
          "source": "if (ctx.totalAmount != null) { ctx.totalAmount = (int) ctx.totalAmount; } if (ctx.totalCount != null) { ctx.totalCount = (int) ctx.totalCount; }"
        },
        "date": {
          "field": "updatedOn",
          "target_field": "updatedOn",
          "formats": ["UNIX_MS"],
          "timezone": "UTC"
        }
      }
    ]
  }'


echo "Applying ingestion pipeline ${INGEST_PIPELINE_NAME} to target index ${SUMMARY_INDEX}..."
curl -X PUT "${OPENSEARCH_HOST}/${SUMMARY_INDEX}/_settings" \
  -k -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD} \
  -H 'Content-Type: application/json' \
  -d '{
    "index.default_pipeline": "integer_conversion_pipeline"
  }'


echo "OpenSearch is up. Creating transforms job '${TRANSFORMS_JOB_NAME}'..."
transforms_creation_output=$(
  curl -X PUT "${OPENSEARCH_HOST}/_plugins/_transform/${TRANSFORMS_JOB_NAME}" \
  -H 'Content-Type: application/json' \
  -d @/usr/local/bin/transforms-job.json -k -u ${OPENSEARCH_USER}:${OPENSEARCH_PASSWORD}
)
echo "Status of creating transforms job '${TRANSFORMS_JOB_NAME}':"
echo $transforms_creation_output

# Wait on background processes to keep the container running
wait
