credit to [zoneminder-containers](https://github.com/zoneminder-containers/eventserver-base).
Also remember, it takes forever to generate the first certificates - track with logs. 

# What

This is a fork of the eventserver-base docker container. See below for changes. I wrote it to support [zmNg](https://github.com/pliablepixels/zmNg)

# Changes

-  To get it working on MacOS, you need to tweak case sensitivity of tables names. `docker-compose` was changed to support this
- Fixes to make sure zmeventnotification logs show up 
- FCM push uses the zmNg cloud function proxy (`zmng-b7af6.cloudfunctions.net/send_push`) — no direct FCM connect or service account needed
- The following files in `overrides/` can be customized and will be persisted across container restarts:
    - `secrets.ini` - these settings will be honored
    - The other files fix bugs in the container (ES logs were not visible, secrets fix as described above)

Also see [notes](notes.txt)

## SSL / HTTPS

ZoneMinder is configured with a self-signed certificate. HTTP (port 80) automatically redirects to HTTPS (port 443).

- Certificates are at `zm/config/ssl/cert.cer` and `zm/config/ssl/key.pem`
- The cert is auto-generated on startup using `ZM_SSL_IP` from `.env` — set this to the IP you access ZoneMinder from (your host/LAN IP)
- If `ZM_SSL_IP` is not set, it falls back to the container's internal IP (which won't match from a browser)
- The cert only regenerates if the IP changes
- To trust it in your browser, copy `zm/config/ssl/cert.cer` and import it

## Event Servers

Two event servers run simultaneously:

| | New ES | Old ES (legacy) |
|---|---|---|
| **Port** | 9001 | 9000 |
| **Source** | [pliablepixels/zmeventnotification](https://github.com/pliablepixels/zmeventnotification) (in `/pp`) | [ZoneMinder/zmeventnotification](https://github.com/ZoneMinder/zmeventnotification) |
| **Config format** | YAML (`zm/config/zmeventnotification.yml`) | INI (`overrides/zmeventnotification_old.ini`) |
| **SSL** | yes | yes |
| **WebSocket URL** | `wss://192.168.50.11:9001` | `wss://192.168.50.11:9000` |

Both use the same self-signed SSL certs. The old ES is mounted from `overrides/zmeventnotification.pl` and runs as a separate s6 service (`zmeventnotification-old`).

#### Push notifications

Both ES instances use the zmNg cloud function proxy for FCM push — no service account or direct FCM connect needed. The FCM key and URL are configured in each ES config file and point to `us-central1-zmng-b7af6.cloudfunctions.net/send_push`.

