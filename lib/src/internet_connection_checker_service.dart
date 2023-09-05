import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'internet_connection_options.dart';
import 'internet_connection_status.dart';

class InternetConnectionCheckerService {
  InternetConnectionCheckerService._();

  factory InternetConnectionCheckerService() {
    _singleton ??= InternetConnectionCheckerService._();
    return _singleton!;
  }

  static InternetConnectionCheckerService? _singleton;

  InternetConnectionStatus? get currentStatus => _currentStatus;

  InternetConnectionStatus? _currentStatus;

  Future<bool> hasInternetAccess({
    required List<InternetConnectionOptions> optionURLs,
  }) async {
    if (optionURLs.isNotEmpty) {
      final result = await Future.wait(
        optionURLs.map(
          (option) => _hasReachabilityNetwork(option),
        ),
      );
      return result.every((element) => element == true);
    }
    return false;
  }

  Stream<InternetConnectionStatus> onInternetConnectionStatusChanged({
    required List<InternetConnectionOptions> optionURLs,
  }) async* {
    final sourceStream = _connectionStatusChanged();
    await for (final event in sourceStream) {
      if (_currentStatus != event) {
        switch (event) {
          case InternetConnectionStatus.connected:
            final hasAccess = await hasInternetAccess(optionURLs: optionURLs);
            if (hasAccess) {
              yield event;
            } else {
              yield InternetConnectionStatus.disconnected;
            }
            break;
          case InternetConnectionStatus.disconnected:
            yield event;
            break;
        }
      }
      _currentStatus = event;
    }
  }

  Future<bool> _hasReachabilityNetwork(
    InternetConnectionOptions options,
  ) async {
    try {
      final dio = Dio();
      final response = await dio.get(options.uri).timeout(options.timeout);
      return response.data != null;
    } on TimeoutException {
      return false;
    }
  }

  InternetConnectionStatus _mapInternetConnectionStatus(
    ConnectivityResult event,
  ) {
    switch (event) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.mobile:
        return InternetConnectionStatus.connected;
      default:
        return InternetConnectionStatus.disconnected;
    }
  }

  Stream<InternetConnectionStatus> _connectionStatusChanged() {
    final internetConnectionStream = Connectivity()
        .onConnectivityChanged
        .map(_mapInternetConnectionStatus)
        .distinct();
    return internetConnectionStream.asBroadcastStream();
  }
}
