import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteService {
  static const String apiKey =
      "eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjZjMmM4OTFjYzEyNzQ0ZmU5NGFkMGI0NjZhMDk5YjI4IiwiaCI6Im11cm11cjY0In0=";

  static Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
      "https://api.openrouteservice.org/v2/directions/driving-car/geojson",
    );

    final response = await http.post(
      url,
      headers: {"Authorization": apiKey, "Content-Type": "application/json"},
      body: jsonEncode({
        "coordinates": [
          [start.longitude, start.latitude],
          [end.longitude, end.latitude],
        ],
      }),
    );

    print("========== ROUTE API ==========");
    print("Status Code: ${response.statusCode}");
    print(response.body);
    print("===============================");

    if (response.statusCode != 200) {
      return [];
    }

    try {
      final data = jsonDecode(response.body);

      final List coords = data["features"][0]["geometry"]["coordinates"];

      return coords
          .map<LatLng>(
            (c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
          )
          .toList();
    } catch (e) {
      print("Parsing Error: $e");
      return [];
    }
  }
}
