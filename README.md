# dilaeitengine

Eigene MOTIS-Instanz für ganz Deutschland (Bus + Bahn), mit Live-Echtzeitdaten
vom offiziellen DELFI-GTFS-RT-Mirror. Die Soll-Fahrplandaten (GTFS) sind ins
Docker-Image eingebacken; die Echtzeitdaten werden zur Laufzeit live abgefragt
(können nicht eingebacken werden, da sie sich laufend ändern).

## Daten-Quelle

- Solldaten: NRW-weiter GTFS-Feed (VRR, VRS, AVV, NWL) -- https://open.nrw/dataset/soll-fahrplandaten-nrw-oepnv
  (wöchentlich aktualisiert, Beta-Qualität laut Anbieter)
- Echtzeit:  https://stc.traines.eu/mirror/german-delfi-gtfs-rt/latest.gtfs-rt.pbf
  (deutschlandweit, MOTIS matched automatisch nur Trips aus den NRW-Solldaten)

## Warum nur NRW statt ganz Deutschland?

Render Free Tier hat nur 512MB RAM. Der komplette Deutschland-Datensatz
(1,7 Mio. Trips) hat das gesprengt (Out of Memory). NRW-weit ist deutlich
kleiner und passt eher. Bei Bedarf später auf einen größeren/eigenen
Server umziehen, um wieder auf ganz Deutschland zu erweitern.

## Setup auf Render

1. Dieses Repo auf GitHub hochladen (Dockerfile + config.yml in den Root legen)
2. Render Dashboard -> **New +** -> **Web Service**
3. **"Build and deploy from a Git repository"** wählen, dieses Repo verbinden
4. Render erkennt automatisch das Dockerfile -- KEIN extra Buildpack nötig
5. Name: `dilaeitengine`
6. Region: Frankfurt
7. Instance Type: **Free**
8. Falls Render den Port nicht automatisch erkennt: unter "Settings" -> Port
   manuell auf `8080` setzen (passend zum `EXPOSE 8080` im Dockerfile)
9. Deploy klicken -- der erste Build dauert länger (Download 256MB + Import)

## Daten aktualisieren

Da die Solldaten eingebacken sind, holt ein einfacher Neustart sie NICHT neu.
Um auf einen aktuelleren Fahrplanstand zu kommen: im Render-Dashboard auf
**"Manual Deploy" -> "Clear build cache & deploy"** klicken -- das lädt das
GTFS.zip neu herunter und backt die aktuelle Version erneut ein.

## API testen

Nach erfolgreichem Deploy ist die MOTIS-API erreichbar unter:

    https://dilaeitengine.onrender.com/api/v5/stoptimes?stopId=...&time=...

Dieselben Endpunkte wie bei api.transitous.org (MOTIS v5 API), nur mit
eigenem Server statt der öffentlichen Transitous-Instanz.
