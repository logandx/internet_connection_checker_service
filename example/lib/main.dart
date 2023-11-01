import 'package:flutter/material.dart';

import 'example/example.dart';

void main() {
  runApp(const HomePage());
}

// Root widget of the application
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Example3(),
    );
  }
}
