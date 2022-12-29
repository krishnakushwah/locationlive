import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});


@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Flutter Demo',
theme: ThemeData(
 primarySwatch: Colors.blue,
),
home: const MyHomePage(title: 'Get Current Location'),
);
}
}

class MyHomePage extends StatefulWidget {
const MyHomePage({super.key, required this.title});


final String title;

@override
State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
var currentAddress = '';

@override
void initState() {
// TODO: implement initState
final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
getCurrentLatLong();
super.initState();
}

Future<void> getCurrentLatLong() async {
final myPosition = await _geolocatorPlatform.getCurrentPosition();

getAddress(myPosition).then((value) {
print(value);
setState(() {
currentAddress = value;
});
});
}

Future<String>getAddress(Position position) async {
if (position.latitude!= null && position.longitude!= null) {
try {
var currentPlace = await placemarkFromCoordinates(
position.latitude, position.longitude);

if (currentPlace!= null && currentPlace.isNotEmpty){
final Placemark place = currentPlace.first;
return "${place.name},${place.thoroughfare},${place
    .subLocality},${place.locality},${place
    .administrativeArea},${place.postalCode},${place.country}";
}
}
on Exception catch (exception) {
print("Location exception: " + exception.toString()); // only executed if error is of type Exception
return "${position.latitude},${position.longitude}";
}
catch(e){
return "${position.latitude},${position.longitude}";
}
} else {
return "Nothing";
}
return "No Address Found";
}


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(widget.title),
),
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
const Text("Your current Location is :"),
Text(currentAddress),
],
),
),
);
}
}
