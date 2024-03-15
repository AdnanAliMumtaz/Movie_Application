import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class InternetChecker extends StatefulWidget {
  final Widget child;

  InternetChecker({required this.child});

  @override
  _InternetCheckerState createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
  late Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _internetConnected = true;
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    // Initialise the Connectivity instance
    _connectivity = Connectivity();
    // Subscribe to the connectivity changes
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        // Update the internet connection status
        _internetConnected = result != ConnectivityResult.none;
      });
      // Show or hide the dialog based on internet connection status
      if (!_internetConnected && !_isDialogOpen) {
        _isDialogOpen = true;
        showNoInternetDialog(context);
      } else if (_internetConnected && _isDialogOpen) {
        _isDialogOpen = false;
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription to avoid memory leaks
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  // Method to show a dialog when there is no internet connection
  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(5), // Change the border radius here
          ),
          title: Text('No Internet Connection'),
          content:
              Text('Please connect to the internet to use this application.'),
        );
      },
    );
  }
}
