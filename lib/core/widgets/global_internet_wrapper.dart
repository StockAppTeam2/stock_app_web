import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class GlobalInternetWrapper extends StatefulWidget {
  final Widget child;

  const GlobalInternetWrapper({super.key, required this.child});

  @override
  State<GlobalInternetWrapper> createState() => _GlobalInternetWrapperState();
}

class _GlobalInternetWrapperState extends State<GlobalInternetWrapper> {
  bool _hasInternet = true;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    _checkInternet();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      _,
    ) async {
      print('Checking Connection...');
      await _checkInternet();
    });
  }

  Future<void> _checkInternet() async {
    final hasInternet = await InternetConnection().hasInternetAccess;
    print('hasInternet $hasInternet');
    if (!mounted) return;

    setState(() {
      _hasInternet = hasInternet;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        if (!_hasInternet)
          Positioned(
            // top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              color: Colors.red,
              elevation: 5,
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: const Text(
                    'No Internet Connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
