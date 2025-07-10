import 'package:flutter/material.dart';

class ErrorMessagePage extends StatelessWidget {
  const ErrorMessagePage({super.key});

  @override
  Widget build(BuildContext context) {

    final errorMessage = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Center(child: Text(errorMessage)),
    );
  }
}
