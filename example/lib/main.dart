import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_service/internet_connection_checker_service.dart';

void main() {
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

// State class for MyApp
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: 'Internet Connection Checker Service Demo',
      ),
    );
  }
}

// Widget for the main page
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State class for MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  // Subscription to internet connection status changes
  StreamSubscription<InternetConnectionStatus>? _streamSubscription;

  // Stores the last known internet connection status
  InternetConnectionStatus? _lastStatus;

  // InternetConnectionCheckerService instance
  final InternetConnectionCheckerService internetConnectionCheckerService =
      InternetConnectionCheckerService();

  // List of URLs to check for internet connectivity
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

    // Listen for internet connection status changes
    _streamSubscription = internetConnectionCheckerService
        .onInternetConnectionStatusChanged(optionURLs: optionURLs)
        .listen((event) {
      if (_lastStatus == null) {
        _lastStatus = event;
        return;
      }
      if (_lastStatus != event) {
        switch (event) {
          case InternetConnectionStatus.connected:
            _lastStatus = InternetConnectionStatus.connected;
            break;
          case InternetConnectionStatus.disconnected:
            _lastStatus = InternetConnectionStatus.disconnected;
            break;
        }
      }
      _lastStatus = event;
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Cancel the stream subscription to prevent memory leaks
    _streamSubscription?.cancel();
    super.dispose();
  }

  // Build the content based on the internet connection status
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
        title: Text(widget.title),
      ),
      body: _buildContent(context),
    );
  }
}
