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
    const InternetConnectionOptions(uri: 'https://google.com'),
    const InternetConnectionOptions(uri: 'https://bing.com'),
  ];

  @override
  void initState() {
    super.initState();
    _streamSubscription = internetConnectionCheckerService
        .onInternetConnectionStatusChanged(optionURLs: optionURLs)
        .distinct()
        .listen((event) {
      setState(() {
        _lastStatus = event;
      });
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
      return const SizedBox.shrink();
    }
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
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
