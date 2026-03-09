credit to [zoneminder-containers](https://github.com/zoneminder-containers/eventserver-base).
Also remember, it takes forever to generate the first certificates - track with logs. 

# What

This is a fork of the eventserver-base docker container. See below for changes. I wrote it to support [zmNg](https://github.com/pliablepixels/zmNg)

# Changes

-  To get it working on MacOS, you need to tweak case sensitivity of tables names. `docker-compose` was changed to support this
- Fixes to make sure zmeventnotification logs show up 
- This version supports two FCM modes. The regular mode is what zmNinja uses - needs an intermediary proxy. The direct mode (new) 
  allows the ES to directly send push messages to [zmNg](https://github.com/pliablepixels/zmNg). In other words you can directly
  control your push ecosystem.
- The following files in `overrides/` can be customized and will be persisted across container restarts:
    - The `zmeventnotification.pl` file is mapped to a local file - so you can change the code. I changed it to:
        - Allow direct FCM access (needs you to place your `service-account` Firebase `JSON` file in `zm/config`)
        - Make sure `fcm_service_account_file = /config/service-account.json` is changed to whatever you call your file
        - You will also need to generate firebase config files for Android/iOS and move it to your device builds
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
| **Port** | 9000 | 9001 |
| **Source** | [pliablepixels/zmeventnotification](https://github.com/pliablepixels/zmeventnotification) (in `/pp`) | [ZoneMinder/zmeventnotification](https://github.com/ZoneMinder/zmeventnotification) |
| **Config format** | YAML (`zm/config/zmeventnotification.yml`) | INI (`overrides/zmeventnotification_old.ini`) |
| **SSL** | yes | yes |
| **WebSocket URL** | `wss://192.168.50.11:9000` | `wss://192.168.50.11:9001` |

Both use the same self-signed SSL certs. The old ES is mounted from `overrides/zmeventnotification.pl` and runs as a separate s6 service (`zmeventnotification-old`).

#### Configuring push notification support

1. Generate a Firebase service account key:
   - Go to Firebase Console > Project Settings > Service Accounts (Make sure its the same project you used for the mobile app)
   - Click **Generate new private key**
   - Save the JSON file to `zm/config`

2. Configure `zm/config/zmeventnotification.ini` 
   ```ini
   fcm_service_account_file = /config/<your service account>.json
   ```
What this does is instruct zmES to directly use FCM push without needing an intermediary

3. Restart the event notification server

