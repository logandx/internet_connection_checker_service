<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# A service for checking internet connection status and accessibility

This package provides methods and streams for checking the current
internet connection status and whether internet access is available
through specified URLs.

For more information, visit the [GitHub repository](https://github.com/logandx/internet_connection_checker_service).

## Features

Check the current internet connection status: disconnected or connected.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

To use this package, make sure to include it in your `pubspec.yaml` file:

```yaml
dependencies:
  internet_connection_checker_service: ^1.0.0
```

Example usage:

```dart
final internetConnectionChecker = InternetConnectionCheckerService();

// Check the current internet connection status.
final status = internetConnectionChecker.currentStatus;

// Listen to changes in internet connection status.
final subscription = internetConnectionChecker
    .onInternetConnectionStatusChanged(optionURLs: [...])
    .listen((status) {
  // Handle the internet connection status change.
});

// Check if internet access is available through specified URLs.
final hasAccess = await internetConnectionChecker.hasInternetAccess(
  optionURLs: [...],
);
```

## Additional information

I've research for some packages that are depended on `connectivity_plus`, and I found that they're not working correctly while determining the actual internet connection changes. So I tried to make this package. The idea is based on `internet_connection_checker`
