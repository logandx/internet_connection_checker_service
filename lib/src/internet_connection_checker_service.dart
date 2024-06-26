import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'internet_connection_options.dart';
import 'internet_connection_status.dart';

class InternetConnectionCheckerService {
  InternetConnectionCheckerService._();

  /// Factory constructor to create a singleton instance of
  /// [InternetConnectionCheckerService].
  ///
  /// This factory constructor ensures that only one instance of the
  /// `InternetConnectionCheckerService` is created and shared across the
  /// application.
  factory InternetConnectionCheckerService() {
    _singleton ??= InternetConnectionCheckerService._();
    return _singleton!;
  }

  static InternetConnectionCheckerService? _singleton;

  /// Default URL to check for internet connectivity.
  ///
  /// This URL is used when no URLs are provided to [hasInternetAccess] method.
  static const String _defaultURL = 'https://www.google.com';

  /// Check if internet access is available.
  ///
  /// This method checks if internet access is available by making a request to
  /// the default URL.
  ///
  /// Returns `connected` if internet access is available, otherwise returns
  /// `disconnected`.
  Future<InternetConnectionStatus> get connectionStatus async {
    final hasAccess = await hasInternetAccess();
    return hasAccess
        ? InternetConnectionStatus.connected
        : InternetConnectionStatus.disconnected;
  }

  /// Check if internet access is available through specified URLs.
  ///
  /// This method takes a list of [InternetConnectionOptions] and checks if
  /// internet access is available by making requests to the provided URLs.
  ///
  /// Returns `true` if internet access is available through all specified URLs,
  /// otherwise returns `false`.
  Future<bool> hasInternetAccess({
    List<InternetConnectionOptions>? optionURLs,
  }) async {
    if (optionURLs != null && optionURLs.isNotEmpty) {
      final result = await Future.wait(
        optionURLs.map(
          (option) => _hasReachabilityNetwork(option),
        ),
      );
      return result.every((element) => element == true);
    } else {
      /// If no URLs are provided, use the default URL.
      final result = await _hasReachabilityNetwork(
        InternetConnectionOptions(uri: _defaultURL),
      );
      return result;
    }
  }

  /// Stream that emits changes in internet connection status.
  ///
  /// This stream provides real-time updates on the internet connection status.
  /// When the status changes, it emits the new status.
  Stream<InternetConnectionStatus> onInternetConnectionStatusChanged({
    List<InternetConnectionOptions>? optionURLs,
  }) async* {
    await for (final event in connectivityStream()) {
      if (event == InternetConnectionStatus.connected) {
        final hasAccess = await hasInternetAccess(optionURLs: optionURLs);
        yield hasAccess ? event : InternetConnectionStatus.disconnected;
      } else {
        yield InternetConnectionStatus.disconnected;
      }
    }
  }

  /// The source stream will be used by [onInternetConnectionStatusChanged]
  /// stream.
  ///
  /// Returns asBroadcastStream. This is crucial when you have multiple
  /// components or parts of your application interested in the same stream of
  /// events without causing interference between them.
  Stream<InternetConnectionStatus> connectivityStream() {
    return Connectivity()
        .onConnectivityChanged
        .map(_mapInternetConnectionStatus)
        .asBroadcastStream();
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
    } catch (e) {
      return false;
    }
  }

  /// Map [ConnectivityResult] to [InternetConnectionStatus].
  ///
  /// Returns the corresponding [InternetConnectionStatus] based on the [event].
  InternetConnectionStatus _mapInternetConnectionStatus(
    List<ConnectivityResult> connectivityResults,
  ) {
    return connectivityResults.any((result) => [
              ConnectivityResult.wifi,
              ConnectivityResult.mobile,
              ConnectivityResult.ethernet
            ].contains(result))
        ? InternetConnectionStatus.connected
        : InternetConnectionStatus.disconnected;
  }
}
