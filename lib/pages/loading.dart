import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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



  void setupWorldTime() async {
    WorldTime instance = WorldTime(city: city, country: country);
    await instance.getTime();
    await Future.delayed(Duration(seconds: 3));
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

      String errorMessage = "Couldn't contact our guy there. Could you try checking your internet connection🤔?";
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
