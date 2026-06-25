# ─── Stage 1: GTFS-Solldaten herunterladen ───────────────────────────────────
FROM debian:bookworm-slim AS fetch
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates wget && \
    rm -rf /var/lib/apt/lists/*
RUN wget -O /GTFS.zip https://download.gtfs.de/germany/free/latest.zip

# ─── Stage 2: MOTIS mit eingebackenen Solldaten ──────────────────────────────
FROM ghcr.io/motis-project/motis:master
WORKDIR /

COPY --from=fetch /GTFS.zip /input/GTFS.zip
COPY config.yml /config.yml

RUN ./motis import

EXPOSE 8080
CMD ["/motis", "server"]
