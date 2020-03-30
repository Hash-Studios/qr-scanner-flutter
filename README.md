# QR Scanner

A Flutter based QR/Bar code scanner app with dark mode and material design.

- [x] Scan QR codes.
- [x] Scan barcodes.
- [x] Show result in a popup.
- [x] Clicking result open the website.
- [x] Result automatically gets copied to clipboard.
- [x] Show snackbar.

## Demo

![Lab: Write your first Flutter app](examples/demo.gif)

## Usage
You can simply clone the repository, or if you want to include it in your project simply follow the steps mentioned below.

First create a new app using `$ flutter create app_name`.

This  project has the following dependencies yo need to define in `pubspec.yaml` file.
```
dependencies:
  cupertino_icons: ^0.1.2
  barcode_scan: ^2.0.1
  flutter_launcher_icons: ^0.7.4
  url_launcher: ^5.4.2
  provider: any
```
It also needs the following assets.
```
flutter:
  uses-material-design: true
  assets:
    - assets/images/logo.jfif
  fonts:
     - family: IBM Plex Sans
       fonts:
         - asset: assets/fonts/IBMPlexSans.ttf
     - family: Raleway
       fonts:
         - asset: assets/fonts/Raleway.ttf
     - family: Rubik
       fonts:
         - asset: assets/fonts/Rubik.ttf
```
where the `logo.jfif` file is the image shown in the drawer of App.

Then run `$ flutter pub get` to download these packages.

Then import the following packages in `main.dart` file.
```
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import './theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
```

You also need to add the following permission in `AndroidManifest.xml` file.
```
<uses-permission android:name="android.permission.CAMERA" />
```
Then add this new activity inside of it.
```
<activity android:name="com.apptreesoftware.barcodescan.BarcodeScannerActivity"/>
```
To add the SplashScreen logo simply add this line to `android/app/src/main/res/drawable/lauch_background.xml` file.
```
    <item>
        <bitmap
            android:gravity="center"
            android:src="@drawable/logo" />
    </item>
```
You also need to add that logo.png inside of the `drawable` folder which is mentioned above.

## Downlaod

You can download the `apk-release.apk`, for using this application.
