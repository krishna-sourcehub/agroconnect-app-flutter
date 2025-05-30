
// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class MapScreen extends StatelessWidget {
  final List<dynamic> markets; // List of maps with lat, long, name

  const MapScreen({super.key, required this.markets});

  @override
  Widget build(BuildContext context) {
    final firstMarket = markets.first;
    final centerLat = firstMarket['lat'];
    final centerLng = firstMarket['long'];

    return Scaffold(
      appBar: AppBar(title: const Text("Markets Map")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(centerLat, centerLng),
          initialZoom: 12.0,
          maxZoom: 16.0,
          minZoom: 3.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=0w1YinL1dp6icJTNZZAi',
            userAgentPackageName: 'com.dev.flutterLearn',

          ),
          // TileLayer(
          //   urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          //   subdomains: ['a', 'b', 'c'],
          //   userAgentPackageName: 'com.example.app',
          // ),
          MarkerLayer(
            markers: markets.map<Marker>((market) {
              return Marker(
                point: LatLng(market['lat'], market['long']),
                width: 100,
                height: 180,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child:Text(
                        market['name'],
                        style: const TextStyle(fontSize: 12, color: Colors.black, backgroundColor: Colors.white70),
                        textAlign: TextAlign.center,

                      ),
                    ),

                    const Icon(Icons.location_pin, color: Colors.red, size: 30),
                  ],
                ),
              );
            }).toList(),
          ),


        ],
      ),
    );
  }
}
