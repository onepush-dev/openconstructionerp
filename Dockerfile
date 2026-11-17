# OpenConstructionERP on Railway: the official upstream image (datadrivenconstruction/openconstructionerp 19.7.0,
# AGPL-3.0), unmodified. This layer only bakes Railway defaults (plain template values don't survive template
# generation): the database parts for the bundled Postgres service (host and password come from template
# references) and data on /data, plus a start wrapper that claims the first-admin slot for a generated owner account. USER root because Railway volumes mount root-owned (upstream runs as uid "oe").
FROM ghcr.io/datadrivenconstruction/openconstructionerp:19.7.0
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/openconstructionerp"
USER root
ENV OE_DB_PORT=5432 \
    OE_DB_USER=postgres \
    OE_DB_NAME=postgres \
    OE_DATA_DIR=/data \
    VECTOR_DATA_DIR=/data/vectors \
    APP_ENV=production \
    SERVE_FRONTEND=true \
    OE_OWNER_EMAIL=owner@example.com
COPY railway/start.sh /railway-start.sh
EXPOSE 8080
ENTRYPOINT ["/railway-start.sh"]
