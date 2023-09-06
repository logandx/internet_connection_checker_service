import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'internet_connection_options.dart';
import 'internet_connection_status.dart';

class InternetConnectionCheckerService {
  InternetConnectionCheckerService._();

  /// Factory constructor to create a singleton instance of [InternetConnectionCheckerService].
  ///
  /// This factory constructor ensures that only one instance of the
  /// `InternetConnectionCheckerService` is created and shared across the
  /// application.
  factory InternetConnectionCheckerService() {
    _singleton ??= InternetConnectionCheckerService._();
    return _singleton!;
  }

  static InternetConnectionCheckerService? _singleton;
  
  InternetConnectionStatus? _currentStatus;

  /// Get the current internet connection status.
  InternetConnectionStatus? get currentStatus => _currentStatus;

  /// Check if internet access is available through specified URLs.
  ///
  /// This method takes a list of [InternetConnectionOptions] and checks if
  /// internet access is available by making requests to the provided URLs.
  ///
  /// Returns `true` if internet access is available through all specified URLs,
  /// otherwise returns `false`.
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
    return true;
  }

  /// Stream that emits changes in internet connection status.
  ///
  /// This stream provides real-time updates on the internet connection status.
  /// When the status changes, it emits the new status.
  Stream<InternetConnectionStatus> onInternetConnectionStatusChanged({
    required List<InternetConnectionOptions> optionURLs,
  }) async* {
    final sourceStream = Connectivity()
        .onConnectivityChanged
        .map(_mapInternetConnectionStatus)
        .distinct()
        .asBroadcastStream();
    await for (final event in sourceStream) {
      if (_currentStatus != event) {
        final hasAccess = await hasInternetAccess(optionURLs: optionURLs);
        if (hasAccess) {
          yield InternetConnectionStatus.connected;
        } else {
          yield InternetConnectionStatus.disconnected;
        }
      }
      _currentStatus = event;
    }
  }

  /// Check internet access by making a request to a URL.
  ///
  /// Returns `true` if internet access is available, otherwise `false`.
  Future<bool> _hasReachabilityNetwork(
    InternetConnectionOptions options,
  ) async {
    try {
      final dio = Dio();
      final response = await dio.get(options.uri).timeout(options.timeout);
      return response.data != null;
    } on SocketException {
      return false;
    }
  }

  /// Map [ConnectivityResult] to [InternetConnectionStatus].
  ///
  /// Returns the corresponding [InternetConnectionStatus] based on the [event].
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
}
