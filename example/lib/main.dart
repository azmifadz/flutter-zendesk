import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zendesk/zendesk.dart';

void main() => runApp(new MyApp());

const ZendeskAccountKey = '<KEY HERE>';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final Zendesk zendesk = Zendesk();

  @override
  void initState() {
    super.initState();
    initZendesk();
    initSupportSDK();
  }

  // Zendesk is asynchronous, so we initialize in an async method.
  Future<void> initZendesk() async {
    zendesk.init(ZendeskAccountKey).then((r) {
      print('init finished');
    }).catchError((e) {
      print('failed with error $e');
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // But we aren't calling setState, so the above point is rather moot now.
  }

  // Zendesk is asynchronous, so we initialize in an async method.
  Future<void> initSupportSDK() async {
    zendesk
        .initSupportSDK(
            '164024bb3f7a1f8ded81b96f41f812f30de94473458b7868',
            'mobile_sdk_client_8590207922485f46dd2d',
            'https://gogetmy.zendesk.com')
        .then((r) {
      print('init support sdk finished');
    }).catchError((e) {
      print('failed with error $e');
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // But we aren't calling setState, so the above point is rather moot now.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('Set User Info'),
                onPressed: () async {
                  zendesk
                      .setVisitorInfo(
                    name: 'My Name',
                    phoneNumber: '323-555-1212',
                  )
                      .then((r) {
                    print('setVisitorInfo finished');
                  }).catchError((e) {
                    print('error $e');
                  });
                },
              ),
              RaisedButton(
                child: Text('test list`'),
                onPressed: () async {
                  zendesk.getList().then((r) {
                    print('startChat finished');
                  }).catchError((e) {
                    print('error $e');
                  });
                },
              ),
              RaisedButton(
                child: Text('Start Support SDK'),
                onPressed: () async {
                  zendesk.startSupportSDK().then((r) {
                    print('startSupportSDK finished');
                  }).catchError((e) {
                    print('error $e');
                  });
                },
              ),
              RaisedButton(
                child: Text('twets SDK'),
                onPressed: () async {
                  zendesk.handleListCallBack().then((r) {
                    print('startSupportSDK finished');
                  }).catchError((e) {
                    print('error $e');
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
