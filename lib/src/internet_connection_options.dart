class InternetConnectionOptions {
  const InternetConnectionOptions({
    required this.uri,
    this.timeout = const Duration(seconds: 5),
  });

  final String uri;
  final Duration timeout;
}
