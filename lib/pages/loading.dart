import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:world_time/services/location_services.dart';
import 'package:geocoding/geocoding.dart';

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

  // LoadingState({required this.city});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSetup();
  }

  void initSetup() async {
    bool check = await checkPermission();
    print("Permission status: $check");

    await getLocation();
    await getCity();
  }


  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    if (!_isInitialized) {
      // Object? temp = ModalRoute.of(context)!.settings.arguments;
      // city = temp.toString() ?? "Kolkata";
      final args = ModalRoute.of(context)!.settings.arguments;

      if(args != null && args is Map) {

        city = args['city'];
        country = args['country'];

      }
      else {
        city = 'San Francisco';
        country = 'United States of America';
      }
      _isInitialized = true;
      setupWorldTime();
    }

  }


  Future<void> getCity() async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(40.7128, -74.0060);

      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks.first;
        print("City: ${place.locality}");
        print("Country: ${place.country}");
      } else {
        print("No placemarks returned.");
      }

    } catch (e, stackTrace) {
      print("Error while getting placemark: $e");
      print("Stack trace: $stackTrace");
    }
  }



  void setupWorldTime() async {
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
      Navigator.pushReplacementNamed(context, '/error_message', arguments: errorMessage);

    }
    else {

      String errorMessage = "We don't have a guy there yet. Maybe try searching for a different city🤔?";
      Navigator.pushReplacementNamed(context, '/error_page', arguments: errorMessage);

    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
