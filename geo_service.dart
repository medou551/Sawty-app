import 'package:geolocator/geolocator.dart';

class GeoService {
  Future<Position> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Service de localisation désactivé');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw Exception('Permission refusée');
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permission refusée définitivement');
    }

    return Geolocator.getCurrentPosition();
  }

  double distanceKm({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) {
    final meters = Geolocator.distanceBetween(
      fromLat,
      fromLng,
      toLat,
      toLng,
    );
    return meters / 1000;
  }
}