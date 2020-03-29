import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import './theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(
    ChangeNotifierProvider<DynamicTheme>(
      create: (_) => DynamicTheme(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.getDarkMode() ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String result = "a";
  TapGestureRecognizer _flutterTapRecognizer;
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "CAMERA permission denied!";
        });
      } else {
        setState(() {
          result = "$ex Error occurred.";
        });
      }
    } on FormatException {
      setState(() {
        result = "Nothing scanned!";
      });
    } catch (ex) {
      setState(() {
        result = "$ex Error occured.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _flutterTapRecognizer = new TapGestureRecognizer()
      ..onTap = () => _openUrl(result);
  }

  @override
  void dispose() {
    _flutterTapRecognizer.dispose();
    super.dispose();
  }

  void _openUrl(String url) async {
    // Close the about dialog.
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
        (Route route) => route == null);

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Problem launching $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context);
    if (result != "a") {
      return new AlertDialog(
        title: const Text('Result'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: result,
                recognizer: _flutterTapRecognizer,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(),
                  ),
                  (Route route) => route == null);
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Okay, got it!'),
          ),
        ],
      );
    } else {
      return Scaffold(
        drawer: Drawer(
          elevation: 0,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Image.asset(
                  'assets/images/logo.jfif',
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 60, 140, 231),
                      Color.fromARGB(255, 0, 234, 255),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                title: Center(
                  child: Text('CodeNameAKshay'),
                ),
                onTap: () {
                  // Navigator.pop(context);
                },
              ),
              Divider(
                height: 2.0,
              ),
              Builder(
                builder: (context) => ListTile(
                  title: Text('Toggle Dark mode'),
                  leading: Icon(Icons.brightness_4),
                  onTap: () {
                    setState(() {
                      themeProvider.changeDarkMode(!themeProvider.isDarkMode);
                    });
                    Navigator.pop(context);
                  },
                  trailing: CupertinoSwitch(
                    value: themeProvider.getDarkMode(),
                    onChanged: (value) {
                      setState(() {
                        themeProvider.changeDarkMode(value);
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Divider(
                height: 2.0,
              ),
              Builder(
                builder: (context) => ListTile(
                  leading: Icon(Icons.open_in_browser),
                  title: new InkWell(
                      child: Text('Visit my website!'),
                      onTap: () {
                        launch('http://codenameakshay.tech');
                        Navigator.pop(context);
                      }),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Divider(
                height: 2.0,
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("QR Scan"),
        ),
        body: Center(
          child: Text(
            "Press scan to scan barcodes or QR codes.",
            style: new TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: "IBM Plex Sans",
            ),
            textAlign: TextAlign.center,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera_alt),
          label: Text("Scan"),
          onPressed: _scanQR,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
  }
}
