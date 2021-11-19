import 'dart:async';

import 'package:flutter/material.dart';
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
      debugPrint('Init sdk ="$result"');
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
      final String result =
          await _channel.invokeMethod('set_identity', arguments);
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

  Future<void> requestWithId(String? requestId) async {

    Map arguments = {
      'requestId': requestId,
    };

    try {
      final String result = await _channel.invokeMethod('request_with_id', arguments);
      print('Start request with id ="$result"');
    } catch (e) {
      print(e);
    }
  }

  Future<void> helpCenter({
    List<int>? articlesForCategoryIds,
    bool? categoriesCollapsed,
    bool? contactUsButtonVisible,
    bool? showConversationsMenuButton,
  }) async {
    Map arguments = {
      'articlesForCategoryIds': articlesForCategoryIds,
      'categoriesCollapsed': categoriesCollapsed,
      'contactUsButtonVisible': contactUsButtonVisible,
      'showConversationsMenuButton': showConversationsMenuButton,
    };

    try {
      final String result =
          await _channel.invokeMethod('help_center', arguments);
      print('Start help center ="$result"');
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> changeNavigationBarVisibility(bool isVisible) async {
    return await _channel.invokeMethod('changeNavigationBarVisibility',
        <String, dynamic>{'isVisible': isVisible});
  }
}
