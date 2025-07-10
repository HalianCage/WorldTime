import 'dart:async';

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class ChooseLocation extends StatefulWidget{
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  //variable to hold the city list
  List<Map<String, String>> _cityData = [];
  List<Map<String, String>> _filteredCityData = [];
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  

  @override
  void initState() {
    super.initState();
    _loadCityData();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }




  //function to load and use city data csv file
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

    _cityData = parsedData;

    setState(() {
      _filteredCityData = _cityData;
    });

    // print("${_cityData.length}");

    // testData = List.generate(50, (i) => {'city': 'City $i'});



    // print("_cityData successfully created ${_cityData[0]}");

  }


  /// function to handle the onchanged property of the textfield.
  /// Implemented using textEditingController and Debouncer
  void _onChanged(String query) {
    // print(_controller.text);
    if(_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(Duration(milliseconds: 300), () {
      setState(() {
        _filteredCityData = _cityData.where((city) {
          final name = city['city']!.toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      });
    });
  }



  //build method
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 50, 95, 80),
        title: Text(
          "Choose Location",
          style: TextStyle(
            fontFamily: 'QuickSand',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: InputDecoration(
                labelText: "Enter city name",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search)
              ),
            ),
          ),
          Expanded(
            child: _filteredCityData.isEmpty? Center(
              child: Text(
                  "Couldn't find this city. Maybe try changing the spelling?🤔",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
              ),
            )
            : ListView.builder(
              itemCount: _filteredCityData.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(
                    '${_filteredCityData[index]['city']}, ${_filteredCityData[index]['country']}',
                    style: TextStyle(fontFamily: 'ShareTech'),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/', arguments: {
                      'city' : _filteredCityData[index]['city'],
                      'country' : _filteredCityData[index]['country']
                    });
                  },
                );
              }
            ),
          )
        ],
      ),
    );
  }
}