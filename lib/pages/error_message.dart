import 'package:flutter/material.dart';

class ErrorMessagePage extends StatelessWidget {
  const ErrorMessagePage({super.key});

  @override
  Widget build(BuildContext context) {

    final errorMessage = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 83, 105, 45),
      ),
      backgroundColor: Color.fromARGB(255, 83, 105, 45),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text(
          errorMessage,
          style: TextStyle(
            fontFamily: 'MuseoModerno',
            fontWeight: FontWeight.bold,
            fontSize: 30,

          ),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
