# ─── Stage 1: GTFS-Solldaten herunterladen ───────────────────────────────────
FROM debian:bookworm-slim AS fetch
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates wget && \
    rm -rf /var/lib/apt/lists/*
# Soll-Fahrplandaten NRW (alle Verbünde: VRR, VRS, AVV, NWL), wöchentlich aktualisiert
# Quelle: https://open.nrw/dataset/soll-fahrplandaten-nrw-oepnv
RUN wget -O /GTFS.zip https://gtfs.openvrr.de/google_transit.zip

# ─── Stage 2: MOTIS mit eingebackenen Solldaten ──────────────────────────────
FROM ghcr.io/motis-project/motis:master
WORKDIR /

COPY --from=fetch /GTFS.zip /input/GTFS.zip
COPY config.yml /config.yml

# Import zur BUILD-Zeit -> Solldaten werden ins Image "eingebacken".
# Echtzeitdaten (GTFS-RT) werden davon NICHT betroffen -- die ruft MOTIS
# beim Serverstart und danach laufend live vom DELFI-Mirror ab.
RUN ./motis import

EXPOSE 8080
CMD ["/motis", "server"]
