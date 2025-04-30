import 'package:geolocator/geolocator.dart';
class LiveLocation {
  double? latitudes=null;
  double? longitudes=null;
  bool isgpsenable = false; // Initially set to false

  // Method to get live location
  Future<void> getLiveLocation() async {
    // Check current permission status
    LocationPermission permission = await Geolocator.checkPermission();

    // Handle the case where permission is denied
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      print("Location permission denied");
      isgpsenable = false;

      // Update local database to reflect location is off
      // await LocalDatabase().setLocationStatus("off");

      // Request permission again
      LocationPermission newPermission = await Geolocator.requestPermission();

      if (newPermission == LocationPermission.denied || newPermission == LocationPermission.deniedForever) {
        print("User denied location permission again");
        isgpsenable = false;

        // Update local database again if permission remains off
        // await LocalDatabase().setLocationStatus("off");
        return; // Exit method if permission is denied
      } else {
        print("User granted location permission");
        isgpsenable = true;

        // Update local database to reflect location is on
        // await LocalDatabase().setLocationStatus("on");
      }
    }

    // If permission is granted, fetch the live location
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      try {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        latitudes = position.latitude;
        longitudes = position.longitude;
        isgpsenable = true;

        // Update local database to reflect location is on
        // await LocalDatabase().setLocationStatus("on");

        print("Live location fetched: Latitude = $latitudes, Longitude = $longitudes");
      } catch (e) {
        print("Error fetching live location: $e");
        isgpsenable = false;

        // Update local database to reflect location is off
        // await LocalDatabase().setLocationStatus("off");
      }
    }
  }


  // Method to return the latitude
  double? getLatitude() {
    return latitudes;
  }
  bool getLocationIsEnable() {
    return isgpsenable;
  }

  void setLatitudes(){
    latitudes=0.0;
  }
  void setLongitudes(){
    longitudes=0.0;
  }
  // Method to return the longitude
  double? getLongitude() {
    return longitudes;
  }
}
