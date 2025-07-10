import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Map data;
  late String backgroundURL;
  Color contentColor = Colors.black;


  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context)!.settings.arguments as Map;
    // print(data);
    // print(data['dateTime'].hour);


    //if-else-if to set background image based on hour
    if( data['dateTime'].hour >= 6 && data['dateTime'].hour < 12) {
      contentColor = Colors.white;
      backgroundURL = "morning.jpeg";
    }
    else if(data['dateTime'].hour >= 12 && data['dateTime'].hour < 17) {
      backgroundURL = "afternoon.jpeg";
    }
    else if(data['dateTime'].hour >= 17 && data['dateTime'].hour < 20) {
      backgroundURL = "evening.jpeg";
    }
    else {
      contentColor = Colors.white12;
      backgroundURL = "night.jpeg";
    }
    // print(backgroundURL);

    // backgroundURL = "morning.jpeg";




    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$backgroundURL'),
              fit: BoxFit.cover,
            ),

          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
              child: Column(
                children: [
                  TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/choose_location');
                      },
                      icon: Icon(Icons.edit_location),
                    label: Text('Choose Location'),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['city'],
                        style: TextStyle(
                          fontSize: 28,
                          letterSpacing: 2,
                          color: contentColor
                        ),
                      ),
                    ],
                  ),
                  Text(
                    data['country'],
                    style: TextStyle(
                      fontSize: 15,
                      color: contentColor
                    ),
                  ),
                  Text(
                    data['time'],
                    style: TextStyle(
                      fontSize: 66,
                      color: contentColor
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}
