import 'dart:async';

import 'package:flutter/material.dart';

import 'package:internet_connection_checker_service/internet_connection_checker_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<InternetConnectionStatus>? _streamSubscription;
  InternetConnectionStatus? _lastStatus;
  final InternetConnectionCheckerService internetConnectionCheckerService =
      InternetConnectionCheckerService();

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
    _streamSubscription?.cancel();
    super.dispose();
  }

  Widget _buildContent(
    BuildContext context,
  ) {
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
