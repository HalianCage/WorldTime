import 'package:flutter/material.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/loading.dart';
// import 'package:world_time/pages/choose_location.dart';
import 'package:world_time/pages/search_page.dart';
import 'package:world_time/pages/error_message.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/choose_location': (context) => ChooseLocation(),
      '/error_page': (context) => ErrorMessagePage()
    },
  ));
}