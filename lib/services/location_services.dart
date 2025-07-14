//ignore_for_file: avoid_print
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

///location package object
loc.Location location = loc.Location();



///Function to check if the location service is enabled or not
Future<bool> checkServiceEnabled() async {

  bool serviceEnabled;

  ///Check if location service is enabled
  serviceEnabled = await location.serviceEnabled();

  if(!serviceEnabled) {

    ///Request location service is not enabled
    serviceEnabled = await location.requestService();

    ///snippet to handle if the location service is not enabled by the user
    if(!serviceEnabled) {

      print("Location services are not enabled");
      return false;

    }
  }

  print("Location service is enabled");
  ///location service is either enabled or has been enabled by the user
  return true;

}



///Function to check and ask for location permission access
Future<bool> checkPermission() async {

  ///variable to store the status of the permission of datatype "PermissionStatus" from the location package
  loc.PermissionStatus permissionGranted;

  ///Checking the current state of permission
  permissionGranted = await location.hasPermission();

  if(permissionGranted == loc.PermissionStatus.denied) {

    ///if permission is denied, then ask for permission from the user
    permissionGranted = await location.requestPermission();

    ///block to handle if the permission is denied by the user
    if(permissionGranted == loc.PermissionStatus.denied || permissionGranted == loc.PermissionStatus.deniedForever) {

      print("Location access permission not granted");
      return false;

    }
  }

  print("Location access permission has been granted");
  ///if permission is already granted or granted right now by the user
  return true;

}


///Function to get the location coordinates of the device in latitude & longitude
Future<List?> getLocation() async {

  try {

    ///function from the location package to fetch the location coordinates of the device of datatype "LocationData" from location package
    loc.LocationData currentLocation = await location.getLocation();
    print(currentLocation.latitude);
    print(currentLocation.longitude);

    List<geo.Placemark> placeMarks = await geo.placemarkFromCoordinates(currentLocation.latitude!, currentLocation.longitude!);
    // print(placeMarks);
    print(placeMarks[0].locality);
    print(placeMarks[0].country);
    return placeMarks;
  }
  catch(e) {
    print("Some error occurred : ");
    print(e);
    return null;
  }

}