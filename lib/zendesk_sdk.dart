import 'dart:async';

import 'package:flutter/services.dart';

class ZendeskSdk {
  static const MethodChannel _channel = MethodChannel('zendesk_sdk');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> initSDK(
    String zendeskUrl,
    String applicationId,
    String clientId,
  ) async {
    Map arguments = {
      'zendeskUrl': zendeskUrl,
      'applicationId': applicationId,
      'clientId': clientId,
    };
    try {
      final String result = await _channel.invokeMethod('init_sdk', arguments);
      print('Init sdk ="$result"');
    } catch (e) {
      print(e);
    }
  }

  Future<void> setIdentity(
      String? token,
      String? name,
      String? email,
      ) async {
    Map arguments = {
      'token': token,
      'name': name,
      'email': email,
    };
    try {
      final String result = await _channel.invokeMethod('set_identity', arguments);
      print('Set identity ="$result"');
    } catch (e) {
      print(e);
    }
  }

  Future<void> initSupport() async {
    try {
      final String result = await _channel.invokeMethod('init_support');
      print('Init support ="$result"');
    } catch (e) {
      print(e);
    }
  }

  Future<void> requestActivity() async {
    try {
      final String result = await _channel.invokeMethod('request');
      print('Start request ="$result"');
    } catch (e) {
      print(e);
    }
  }

  Future<void> requestList() async {
    try {
      final String result = await _channel.invokeMethod('request_list');
      print('Start request list ="$result"');
    } catch (e) {
      print(e);
    }
  }

  Future<void> helpCenter() async {
    try {
      final String result = await _channel.invokeMethod('help_center');
      print('Start help center ="$result"');
    } catch (e) {
      print(e);
    }
  }
}
