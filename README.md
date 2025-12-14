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
