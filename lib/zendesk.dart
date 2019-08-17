import 'dart:async';

import 'package:flutter/services.dart';

class Zendesk {
  static const MethodChannel _channel =
      const MethodChannel('com.codeheadlabs.zendesk');

  Future<void> init(String accountKey) async {
    await _channel.invokeMethod('init', <String, String>{
      'accountKey': accountKey,
    });
  }

  Future<void> initSupportSDK(String appId, String clientId, String url) async {
    await _channel.invokeMethod('initSupportSDK', <String, String>{
      'appId': appId,
      'clientId': clientId,
      'url': url,
    });
  }

  Future<void> setVisitorInfo({String name, String email, String phoneNumber, String note}) async {
    await _channel.invokeMethod('setVisitorInfo', <String, String>{
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'note': note,
    });
  }

  Future<void> startChat() async {
    await _channel.invokeMethod('startChat');
  }

  Future<void> startSupportSDK() async {
    await _channel.invokeMethod('startSupportSDK');
  }
}
