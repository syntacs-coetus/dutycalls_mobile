import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class GoogleMaps extends StatelessWidget{
  final double long;
  final double lat;
  final double provlong;
  final double provlat;

  GoogleMaps({this.provlat, this.provlong, this.lat, this.long});

 Widget build(BuildContext context){
   return MaterialApp(
     title: 'Map',
     home: TheMap(provlat: provlat, provlong: provlong, lat: lat, long: long),
   );
 }
}

class TheMap extends StatefulWidget{
  final double long;
  final double lat;
  final double provlong;
  final double provlat;

  TheMap({this.provlat, this.provlong, this.lat, this.long});
 @override
 State<TheMap> createState() => TheMapFullState(provlat: provlat, provlong: provlong, lat: lat, long: long);
}

class TheMapFullState extends State<TheMap> {
  final double long;
  final double lat;
  final double provlong;
  final double provlat;
  TheMapFullState({this.provlat, this.provlong, this.lat, this.long});
 @override
 Widget build(BuildContext context){
   return Scaffold(
      appBar: AppBar(
        title: Text("Job Map"),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: new FlutterMap(
          options: new MapOptions(
            center: new LatLng(provlat, provlong),
            zoom: 18.0,
          ),
          layers: [
            new TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']
            ),
            new MarkerLayerOptions(
              markers: [
                new Marker(
                  width: 60.0,
                  height: 60.0,
                  point: new LatLng(provlat, provlong),
                  builder: (ctx) =>
                  new Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/users/default-profile.jpg'),
                        fit: BoxFit.contain,
                      ),
                      borderRadius: BorderRadius.circular(80.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 10.0,
                      ),
                    ),
                  ),
                ),
                new Marker(
                  width: 60.0,
                  height: 60.0,
                  point: new LatLng(lat, long),
                  builder: (ctx) =>
                  new Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/app/logo.png'),
                        fit: BoxFit.contain,
                      ),
                      borderRadius: BorderRadius.circular(80.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 10.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      )
   );
 }
}