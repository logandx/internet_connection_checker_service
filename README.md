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

# **Introduction**

This package provides methods and streams for checking the current
internet connection status and whether internet access is available
through specified URLs.

## **Features**

- Check the current internet connection status: disconnected or connected.
- Determine the internet connection on specific URLs.

## **Usage**

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

## **Additional information**

I conducted research on packages that rely on `connectivity_plus` and noticed that they do not accurately detect changes in internet connectivity. As a result, I decided to develop a new package inspired by `internet_connection_checker` to address these issues and provide more reliable internet connection change detection."

If you have more specific details or questions related to creating this package or need further assistance, please feel free to ask.
