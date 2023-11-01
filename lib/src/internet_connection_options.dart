/// Represents options for checking internet connectivity.
class InternetConnectionOptions {
  /// Creates an instance of [InternetConnectionOptions] with the provided URI
  /// and optional timeout.
  ///
  /// The [uri] should be a valid URL to check internet connectivity.
  ///
  /// The [timeout] specifies the maximum duration to wait for a response from
  /// the URL before considering it as a timeout and indicating no internet
  /// access.
  const InternetConnectionOptions({
    required this.uri,
    this.timeout = const Duration(seconds: 5),
  });

  /// The URL to be checked for internet connectivity.
  final String uri;

  /// The maximum duration to wait for a response from the URL before timing out.
  final Duration timeout;
}
