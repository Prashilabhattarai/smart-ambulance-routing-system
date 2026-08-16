import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPreview extends StatelessWidget {
  const MapPreview({super.key, required this.location});

  final LatLng location;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: location,
        initialZoom: 15,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      ),

      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: "com.example.smart_ambulance_app",
        ),

        MarkerLayer(
          markers: [
            Marker(
              point: location,
              width: 50,
              height: 50,
              child: const Icon(
                Icons.location_on_rounded,
                color: Color(0xFF2563EB),
                size: 45,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
