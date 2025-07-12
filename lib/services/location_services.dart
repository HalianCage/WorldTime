import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

loc.Location location = loc.Location();


///Function to check and ask for location permission
Future<bool> checkPermission() async {

  bool serviceEnabled;
  loc.PermissionStatus permissionGranted;

  ///Check if location service is enabled
  serviceEnabled = await location.serviceEnabled();

  if(!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if(!serviceEnabled) {
      print("Location services are not enabled");
      return false;
    }
  }

  ///Ask for location access permission
  permissionGranted = await location.hasPermission();

  if(permissionGranted == loc.PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if(permissionGranted == loc.PermissionStatus.denied || permissionGranted == loc.PermissionStatus.deniedForever) {
      print("Location access permission not granted");
      return false;
    }
  }

  return true;

}

Future<void> getLocation() async {

  try {
    loc.LocationData currentLocation = await location.getLocation();
    print(currentLocation.latitude);
    print(currentLocation.longitude);

    // List<geo.Placemark> placeMarks = await geo.placemarkFromCoordinates(37.4219983, -122.084);
    // print(placeMarks);
  }
  catch(e) {
    print("Some error occurred : ");
    print(e);
  }

}