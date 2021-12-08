import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zendesk_sdk/zendesk_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _platformVersion = 'Unknown';
  final String _zendeskUrl = '';
  final String _applicationId = '';
  final String _clientId = '';
  final String _jwtIdentity = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initZendeskSdk();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint("didChangeAppLifecycleState >>>> " + state.toString());
    if (state == AppLifecycleState.resumed) {
      ZendeskSdk().changeNavigationBarVisibility(false);
    } else {
      ZendeskSdk().changeNavigationBarVisibility(true);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await ZendeskSdk.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> initZendeskSdk() async {
    await ZendeskSdk().initSDK(_zendeskUrl, _applicationId, _clientId);
    await ZendeskSdk().setIdentity(_jwtIdentity, 'Test', 'test@mail.com');
    // Initialize Support SDK
    await ZendeskSdk().initSupport();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                onPressed: () async {
                  ZendeskSdk().requestActivity();
                },
                child: const Text("New Request"),
              ),
              ElevatedButton(
                onPressed: () async {
                  ZendeskSdk().requestList();
                },
                child: const Text("Request List"),
              ),
              ElevatedButton(
                onPressed: () async {
                  ZendeskSdk().requestWithId("113101");
                },
                child: const Text("Request With Id"),
              ),
              ElevatedButton(
                onPressed: () async {
                  ZendeskSdk().helpCenter(
                    articlesForCategoryIds: [201732367],
                    contactUsButtonVisible: false,
                    showConversationsMenuButton: false,
                  );
                },
                child: const Text("Help Center"),
              ),
              ElevatedButton(
                onPressed: () async {
                  ZendeskSdk().articleWithId("360015668233", false);
                },
                child: const Text("Article With Id"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
