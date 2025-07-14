//ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:world_time/services/location_services.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});


  @override
  State<Loading> createState() => LoadingState();
}

class LoadingState extends State<Loading> {

  bool _isInitialized = false;
  late String city;
  late String country;
  late String time;
  late String date;
  late bool permissionCheck;
  late bool serviceEnabledCheck;
  late List? placeMark;
  bool usedDeviceLocation = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {

      _isInitialized = true;
      _initSetup();

    }
  }

  ///function to get the correct city and country
  ///Has 3 possible options -
  ///1)City and country is passed on from the search_page.dart, which is a user selection. Highest Priority.
  ///2)Using device location, city and country are fetched using custom functions. Second priority.
  ///3)Default values. Act as fallback values. Least priority.
  Future<void> _initSetup() async {

    ///accessing data sent(if any) sent from the search_page.dart
    final args = ModalRoute.of(context)?.settings.arguments;

    ///If block to use the search_page.dart selection
    if(args != null && args is Map && args['city'] != null && args['country'] != null) {

      city = args['city'];
      country = args['country'];

    }
    else {

      try {

        ///Checking and asking for location access permission and also for location service.
        permissionCheck = await checkPermission();
        serviceEnabledCheck = await checkServiceEnabled();

        ///If block to use the device location if both the permission is granted and the location service is enabled.
        if(permissionCheck && serviceEnabledCheck) {

          print("Both permissions granted");
          ///get device location
          placeMark = await getLocation();
          // print(placeMark);

          if(placeMark != null) {

            city = placeMark![0].locality;
            country = placeMark![0].country == "United States" ? "United States of America" : placeMark![0].country;
            usedDeviceLocation = true;
            print("Device location has been successfully accessed and used");

          }
          else {

            print("Placemark is null");
            _defaultLocation();
          }

        }
        else {

          print("A permission has not been granted");
          _defaultLocation();
        }

      }
      catch(e, stackTrace) {

        print("Some error Occurred: $e");
        print("Stack Trace: $stackTrace");
        _defaultLocation();

      }
    }

    await setupWorldTime();

  }

  void _defaultLocation() {

    setState(() {
      city = "San Francisco";
      country = "United States of America";
    });

  }

  // void debugIsolate() {
  //   print('Running on isolate: ${Isolate.current.debugName}');
  // }


  Future<void> setupWorldTime({bool isFallBackAttempt = false}) async {
    WorldTime instance = WorldTime(city: city, country: country);
    await instance.getTime();
    await Future.delayed(Duration(seconds: 2));
    // print(instance.statusCheck);
    if(!mounted) return;

    if(instance.statusCheck == 202) {
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'city' : instance.city,
        'country' : instance.country,
        'date' : instance.date,
        'time' : instance.time,
        'dateTime' : instance.dateTime
      });
    }
    else if(instance.statusCheck == 401) {

      String errorMessage = "Couldn't contact our guy there. Try checking your internet connection maybe🤔?";
      Navigator.pushReplacementNamed(context, '/error_page', arguments: errorMessage);

    }
    else if(instance.statusCheck == 402 && usedDeviceLocation && !isFallBackAttempt) {

      print("Unsupported location. Falling back to default");
      _defaultLocation();
      await setupWorldTime(isFallBackAttempt: true);

    }
    else {

      String errorMessage = "We don't have a guy there yet. Maybe try searching for a different city🤔?";
      Navigator.pushReplacementNamed(context, '/error_page', arguments: errorMessage);

    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 83, 105, 45),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Asking our guy there, please wait...',
              style: TextStyle(
                fontSize: 20
              ),
            ),
            SizedBox(height: 20),
            const SpinKitCircle(
              color: Colors.grey,
              size: 50,
            ),
          ],
        )
      )
    );
  }
}
