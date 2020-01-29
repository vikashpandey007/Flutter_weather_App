import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

import 'package:splashscreen/splashscreen.dart';
import 'package:weather_app/Homepage.dart';

main() {
  runApp(DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
            primaryColor: Colors.white,
            // primarySwatch: Colors.indigo,
            brightness: brightness,
          ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: new Myapp(),
        );
      }));
}

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 2,
        navigateAfterSeconds: new Home(),
        image: Image(
          image: AssetImage("assets/Weather5.png"),
        ),
        title: new Text(
          ' CHECK YOUR PLACE WEATHER ',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 200.0,
        loaderColor: Colors.red);
  }
}
