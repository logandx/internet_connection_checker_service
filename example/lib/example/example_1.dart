import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_service/internet_connection_checker_service.dart';

class Example1 extends StatefulWidget {
  const Example1({
    super.key,
  });

  @override
  State<Example1> createState() => _Example1State();
}

class _Example1State extends State<Example1> with WidgetsBindingObserver {
  StreamSubscription<InternetConnectionStatus>? _streamSubscription;
  InternetConnectionStatus? _lastStatus;
  final InternetConnectionCheckerService internetConnectionCheckerService =
      InternetConnectionCheckerService();

  // List of URLs to check for internet connection
  List<InternetConnectionOptions> optionURLs = [
    const InternetConnectionOptions(
      uri: 'https://google.com',
      timeout: Duration(seconds: 20),
    ),
    const InternetConnectionOptions(
      uri: 'https://bing.com',
      timeout: Duration(seconds: 20),
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Subscribe to internet connection status changes
    _streamSubscription = internetConnectionCheckerService
        .onInternetConnectionStatusChanged(optionURLs: optionURLs)
        .listen((event) {
      _lastStatus = event;
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Cancel the subscription and remove observer when the widget is disposed
    _streamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Resume the internet connection status subscription when the app is resumed
      _streamSubscription?.resume();
    } else if (state == AppLifecycleState.paused) {
      // Pause the subscription when the app is paused
      _streamSubscription?.pause();
    }
  }

  Widget _buildContent(BuildContext context) {
    if (_lastStatus == null) {
      return Center(
        child: Text('$_lastStatus'),
      );
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: _lastStatus == InternetConnectionStatus.disconnected
            ? Colors.red
            : Colors.green,
        child: Text(
          _lastStatus == InternetConnectionStatus.disconnected
              ? 'Disconnected'
              : 'Connected',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internet Connection Checker Example'),
      ),
      body: Column(
        children: [
          _buildContent(context),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // Check for internet access and display a snackbar message
              final hasAccess = await internetConnectionCheckerService
                  .hasInternetAccess(optionURLs: optionURLs);
              if (!context.mounted) {
                return;
              }
              if (hasAccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Internet access is available.'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Internet access is not available.'),
                  ),
                );
              }
            },
            child: const Text('Check Internet Access'),
          ),
        ],
      ),
    );
  }
}
