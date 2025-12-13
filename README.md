Full credit to [zoneminder-containers](https://github.com/zoneminder-containers/eventserver-base).

Also remember, it takes forever to generate the first certificates - track with logs. 

# Changes

-  To get it working on MacOS, you need to tweak case sensitivity of tables names. `docker-compose` was changed to support this
- Fixes to make sure zmeventnotification logs show up 
- The `zmeventnotification.pl` file is mapped to a local file - so you can change the code. I changed it to:
    - Allow direct FCM access (needs you to place your `service-account` Firebase `JSON` file in `zm/config`)
    - Make sure `fcm_service_account_file = /config/service-account.json` is changed to whatever you call your file
    - You will also need to generate firebase config files for Android/iOS and move it to your device builds
