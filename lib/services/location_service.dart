import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationService extends GetxService {
  Future<Position> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error(
          'Location services are disabled. Please enable them.',
          StackTrace.current,
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error(
            'Location permissions are denied',
            StackTrace.current,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
          'Location permissions are permanently denied. Please enable in app settings.',
          StackTrace.current,
        );
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10), // Add timeout
      );
    } catch (e, stack) {
      return Future.error('Failed to get location: ${e.toString()}', stack);
    }
  }

  Future<Placemark> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng).timeout(
        const Duration(seconds: 5), // Add timeout
        onTimeout: () => throw 'Address lookup timed out',
      );

      if (placemarks.isEmpty) {
        throw 'No address found for these coordinates';
      }

      return placemarks.first;
    } catch (e, stack) {
      return Future.error('Address lookup failed: ${e.toString()}', stack);
    }
  }

  // Helper method to open app settings
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  // Helper method to open location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}