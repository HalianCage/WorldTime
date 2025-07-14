//ignore_for_file: avoid_print

import 'package:http/http.dart';
import 'dart:convert';


class WorldTime {

  late Map cityData;
  late String city; //city name for searching
  late String country; //country name for accurate searching
  late String date;
  late String time; //the time in that city
  late String time24;
  late DateTime dateTime;
  late int statusCheck;


  ///StatusCheck Codes -
  ///201 - WorldTime API fetch successful('ok' or 'error' status data)
  ///202 - 'ok' data successfully fetched from WorldTime API
  ///401 - WorldTime API fetch unsuccessful
  ///402 - 'error' data fetched from WorldTime API



  WorldTime({ required this.city, required this.country});



  Future<void> getTime() async {

    late Map data;

    //try-catch block to make api request
    try {

      final apiUri = Uri.parse('https://api.apiverve.com/v1/worldtime?city=$city');
      Map<String, String> header = { "x-api-key": "13d45c66-3e30-4181-82e8-33668e428938" };
      Response response = await get(apiUri, headers: header);
      data = jsonDecode(response.body);
      statusCheck = 201;

    } catch (e) {

      print("caught error : Unable to access world time API. Check your internet connection or API link. $e");
      statusCheck = 401;


    }



    
    //status check
    if(data['status'] == 'ok') {

      print('World time API fetch successful');
      statusCheck = 202;

      //extracting the list of all found cities
      final foundCities = data['data']['foundCities'] as List;
      // print(foundCities[0]['country']);


      //for loop to filter the correct country
      for(int i = 0; i < foundCities.length; i++) {
        if(foundCities[i]['country'] == country) {
          cityData = foundCities[i];
          break;
        }
      }

      //extracting time and date
      time24 = cityData['time24']; //for DateTime parsing
      time = cityData['time12'];
      date = cityData['date'];
      // print('Time : $time');
      // print('Date : $date');


      //Formatting time to omit seconds for better UI
      time = time.substring(0, 5) + time.substring(8);



      //DateTime parsing in 24 hour format for Day or night categorization
      dateTime = DateTime.parse("$date $time24");
      // print(dateTime.hour);

    }
    else {
       print("caught error : Apiverve world time API fetch unsuccessful. Status: ");
       print(data['status']);
       statusCheck = 402;
    }
  }
}