import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_service/internet_connection_checker_service.dart';

/// Try to turn off the internet connection and see the result.
class Example3 extends StatefulWidget {
  const Example3({
    super.key,
  });

  @override
  State<Example3> createState() => _Example3State();
}

class _Example3State extends State<Example3> with WidgetsBindingObserver {
  final _internetConnectionCheckerService = InternetConnectionCheckerService();
  StreamSubscription<InternetConnectionStatus>? _streamSubscription;
  InternetConnectionStatus? _lastStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _streamSubscription = _internetConnectionCheckerService
        .onInternetConnectionStatusChanged()
        .listen((event) {
      _lastStatus = event;
      setState(() {});
    });
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

  @override
  void dispose() {
    _streamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: _AnimatedInternetStatus(status: _lastStatus),
    );
  }
}

class _AnimatedInternetStatus extends StatelessWidget {
  const _AnimatedInternetStatus({
    this.status,
  });

  final InternetConnectionStatus? status;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AnimatedSwitcher(
      switchInCurve: Curves.fastOutSlowIn,
      switchOutCurve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: child,
        );
      },
      child: status != null && status == InternetConnectionStatus.disconnected
          ? Container(
              padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top,
                bottom: 8,
              ),
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                'You are currently offline.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            )
          : SizedBox.fromSize(
              size: Size(
                size.width,
                0,
              ),
            ),
    );
  }
}
