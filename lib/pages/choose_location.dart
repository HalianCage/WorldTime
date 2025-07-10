///
///
///
/// THIS IS A DEPRECATED FILE.
/// IT HAS BEEN REPLACED WITH "search_page.dart" FILE WITH ADDITIONAL SEARCH BAR FUNCTIONALITY.
///
///
///
library;



import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();

}

class _ChooseLocationState extends State<ChooseLocation> {

  List<Map<String, String>> _cityData = [];
  // List<Map<String, String>> testData = [];


  @override
  void initState() {
    super.initState();
    _loadCityData();
  }



  ///function to load and use city data csv file
  Future<void> _loadCityData() async {

    // print("Inside CSV function");

    //loading csv file data into a String identifier
    final rawData = await rootBundle.loadString('assets/worldcities.csv');

    // print("CSV data extraction into string complete");

    //converting String data to list list type
    final List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);


    //creating a list of all column names
    final headers = csvTable.first.map((e) => e.toString()).toList();


    //omitting the first row of column names
    final finalCsvTable = csvTable.skip(1).toList();


    List<Map<String, String>> parsedData = finalCsvTable.map((row) {
      return {

        for(int i=0; i < headers.length; i++) headers[i] : row[i].toString(),

      };
    }).toList();


    setState(() {

      _cityData = parsedData;

    });

    // print("${_cityData.length}");

    // testData = List.generate(50, (i) => {'city': 'City $i'});



    // print("_cityData successfully created ${_cityData[0]}");

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Choose Location'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _cityData.isEmpty? Center(child: CircularProgressIndicator(),)
      : ListView.builder(
        itemCount: _cityData.length,
        itemBuilder: (_, index){
          return ListTile(
            title: Text('${_cityData[index]['city']}, ${_cityData[index]['country']}'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/', arguments: {
                'city' : _cityData[index]['city'],
                'country' : _cityData[index]['country']
              });
            },
          );
        },
      )
    );
  }
}
