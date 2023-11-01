import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_service/internet_connection_checker_service.dart';

class Example2 extends StatelessWidget {
  const Example2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Internet Connection Checker Service Example 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your internet connection status is:',
            ),
            ElevatedButton(
              onPressed: () async {
                // Check the internet connection status
                final status =
                    await InternetConnectionCheckerService().connectionStatus;

                // Log the connection status to the console
                if (status == InternetConnectionStatus.connected) {
                  log("Connected");
                } else {
                  log("Disconnected");
                }
              },
              child: const Text('Check Status'),
            ),
          ],
        ),
      ),
    );
  }
}
