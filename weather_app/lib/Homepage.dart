import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int temperature, minTemp, maxTemp;
  var sunrise, sunset;
  var location = TextEditingController();
  var searchlocation = "Jaipur";
  var url, urllocaton, convertdata1;

  Position _currentPosition;
  String latitude;
  String longitude;

  var convertdata;
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        fetchlocationdata();
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<String> fetchData() async {
    url =
        "http://api.openweathermap.org/data/2.5/weather?q=$searchlocation&appid=c1e37b58611830aa871ec73d48480523";
    var response = await http.get(Uri.encodeFull(url));
    setState(() {
      convertdata = json.decode(response.body);
      sunrise = DateTime.fromMillisecondsSinceEpoch(
          convertdata["sys"]["sunrise"] * 1000);
      sunset = DateTime.fromMillisecondsSinceEpoch(
          convertdata["sys"]["sunset"] * 1000);
      temperature = (convertdata["main"]["temp"] - 273).truncate();
      minTemp = (convertdata["main"]["temp_min"] - 273).truncate();
      maxTemp = (convertdata["main"]["temp_max"] - 273).truncate();
      sunrise = DateTime.fromMillisecondsSinceEpoch(
          convertdata["sys"]["sunrise"] * 1000);
      sunset = DateTime.fromMillisecondsSinceEpoch(
          convertdata["sys"]["sunset"] * 1000);
    });
    print(response.body);
  }

  Future<String> fetchlocationdata() async {
    print("object");
    latitude = "${_currentPosition.latitude}";
    longitude = "${_currentPosition.longitude}";
    print(latitude);
    print(longitude);

    urllocaton =
        "http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=198c3d478febaa60a34b02cc3bf02540";

    var response = await http.get(Uri.encodeFull(urllocaton));

    print(urllocaton);

    setState(() {
      convertdata1 = json.decode(response.body);
      print(convertdata);
      sunrise = DateTime.fromMillisecondsSinceEpoch(
          convertdata1["sys"]["sunrise"] * 1000);
      sunset = DateTime.fromMillisecondsSinceEpoch(
          convertdata1["sys"]["sunset"] * 1000);
      temperature = (convertdata1["main"]["temp"] - 273).truncate();
      minTemp = (convertdata1["main"]["temp_min"] - 273).truncate();
      maxTemp = (convertdata1["main"]["temp_max"] - 273).truncate();
      sunrise = DateTime.fromMillisecondsSinceEpoch(
          convertdata1["sys"]["sunrise"] * 1000);
      sunset = DateTime.fromMillisecondsSinceEpoch(
          convertdata1["sys"]["sunset"] * 1000);
      searchlocation = convertdata1["name"];
    });

    print("searchlocation: $searchlocation");
  }

  getlocation() {
    setState(() {
      searchlocation = location.text;
      fetchData();
    });
  }

  @override
  void initState() {
    fetchData();
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return convertdata != null
        ? Scaffold(
            body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/weather4.jpeg"),
                        fit: BoxFit.cover)),
              ),
              ListView(
                children: <Widget>[
                  Card(
                    color: Colors.transparent,
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 55,
                          margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                          child: TextField(
                            controller: location,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey,
                                hintText: "  Enter City Name",
                                hintStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35))),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 30,
                              child: MaterialButton(
                                onPressed: () {
                                  getlocation();
                                },
                                color: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "Search",
                                ),
                              ),
                            ),
                            FlatButton(
                              child: Text(
                                "Get location",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                _getCurrentLocation();
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 30, bottom: 16),
                          child: Text(
                            searchlocation,
                            style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 0, right: 0, top: 0),
                          child: Text(
                            "$temperature°c",
                            style: TextStyle(fontSize: 80, color: Colors.white),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 40),
                                ),
                                Text(
                                  "$minTemp~",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                                Text("$maxTemp",
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white)),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 140),
                              child: Text(
                                  "${convertdata["weather"][0]["main"]}",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white)),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              height: 0.4,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "17",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Text(
                                        "⛅ ",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "15c",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "18",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Text(
                                        "🌦 ",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "16c",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "19",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Text(
                                        "🌧 ",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "18c",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "20",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Text(
                                        "⛅ ",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "17c",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "21",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Text(
                                        "⛅ ",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "19c",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "22",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Text(
                                        "⛅ ",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "19c",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                      height: 0.4,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              height: 0.4,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              height: 0.4,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Image.network(
                                          "http://pngimg.com/uploads/thermometer/thermometer_PNG93.png"),
                                    ),
                                    Text(
                                      "Feels like",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    Text(
                                      "$temperature°c",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    Container(
                                      height: 60,
                                      width: 60,
                                      child: Image.network(
                                          "http://www.pngmart.com/files/8/Sunrise-PNG-Transparent-Background.png"),
                                    ),
                                    Text(
                                      "Sunrise",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    Text(
                                      sunrise.toString().substring(10, 16),
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Text(
                                        "💧",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "Air humidity",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    Text(
                                      "${convertdata["main"]["humidity"]}%",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    Container(
                                      height: 60,
                                      width: 60,
                                      child: Image.network(
                                          "http://www.pngmart.com/files/8/Sunrise-PNG-Transparent-Background.png"),
                                    ),
                                    Text(
                                      "Sunset",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    Text(
                                      sunset.toString().substring(10, 16),
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                        height: 40,
                                        width: 40,
                                        child: Text(
                                          "💨  ",
                                          style: TextStyle(fontSize: 28),
                                        )),
                                    Text(
                                      "Wind",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    Text(
                                      "NE,forse ${convertdata["wind"]["speed"]}",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Text(
                                        "🕛",
                                        style: TextStyle(
                                            fontSize: 24, color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "Pressure",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    Text(
                                      "${convertdata["main"]["pressure"]} hPa",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              height: 0.4,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ))
        : Container();
  }
}
