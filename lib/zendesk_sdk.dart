import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZendeskSdk {
  static const MethodChannel _channel = MethodChannel('zendesk_sdk');

  static void _log(String message) {
    debugPrint('[ZendeskSdk] $message');
  }

  static void _logError(String method, Object error) {
    _log('$method failed: ${error.runtimeType}: $error');
    if (error is PlatformException) {
      _log(
        '$method PlatformException: '
        'code=${error.code}, message=${error.message}, details=${error.details}',
      );
    }
  }

  static String _presence(String? value) {
    if (value == null) return 'null';
    if (value.isEmpty) return 'empty';
    return 'present';
  }

  static String _urlSummary(String zendeskUrl) {
    final uri = Uri.tryParse(zendeskUrl);
    if (uri == null) return 'invalid';
    if (uri.host.isNotEmpty) return uri.host;
    if (uri.path.isNotEmpty) return uri.path;
    return 'empty';
  }

  static Future<String?> get platformVersion async {
    _log('getPlatformVersion called');
    try {
      final String? version = await _channel.invokeMethod('getPlatformVersion');
      _log('getPlatformVersion result="$version"');
      return version;
    } catch (e) {
      _logError('getPlatformVersion', e);
      rethrow;
    }
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
    _log(
      'initSDK called: '
      'zendeskUrlHost=${_urlSummary(zendeskUrl)}, '
      'zendeskUrl=${_presence(zendeskUrl)}, '
      'applicationId=${_presence(applicationId)}, '
      'clientId=${_presence(clientId)}',
    );
    try {
      final String result = await _channel.invokeMethod('init_sdk', arguments);
      _log('initSDK native result="$result"');
    } catch (e) {
      _logError('initSDK', e);
      rethrow;
    }
  }

  Future<void> setIdentity(String? token, String? name, String? email) async {
    Map arguments = {'token': token, 'name': name, 'email': email};

    final identityType = token != null ? 'jwt' : 'anonymous';
    _log(
      'setIdentity called: '
      'identityType=$identityType, '
      'token=${_presence(token)}, '
      'name=${_presence(name)}, '
      'email=${_presence(email)}',
    );
    if (token != null && token.isEmpty) {
      _log(
        'setIdentity warning: token is empty; native code currently treats '
        'this as JWT identity because the token is non-null',
      );
    }

    try {
      final String result = await _channel.invokeMethod(
        'set_identity',
        arguments,
      );
      _log('setIdentity native result="$result"');
    } catch (e) {
      _logError('setIdentity', e);
      rethrow;
    }
  }

  Future<void> initSupport() async {
    _log('initSupport called');
    try {
      final String result = await _channel.invokeMethod('init_support');
      _log('initSupport native result="$result"');
    } catch (e) {
      _logError('initSupport', e);
      rethrow;
    }
  }

  Future<void> requestActivity() async {
    _log('requestActivity called');
    try {
      final String result = await _channel.invokeMethod('request');
      _log('requestActivity native result="$result"');
    } catch (e) {
      _logError('requestActivity', e);
      rethrow;
    }
  }

  Future<void> requestList() async {
    _log('requestList called');
    try {
      final String result = await _channel.invokeMethod('request_list');
      _log('requestList native result="$result"');
    } catch (e) {
      _logError('requestList', e);
      rethrow;
    }
  }

  Future<void> requestWithId(String? requestId) async {
    Map arguments = {'requestId': requestId};

    _log('requestWithId called: requestId=${_presence(requestId)}');
    try {
      final String result = await _channel.invokeMethod(
        'request_with_id',
        arguments,
      );
      _log('requestWithId native result="$result"');
    } catch (e) {
      _logError('requestWithId', e);
      rethrow;
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

    _log(
      'helpCenter called: '
      'categoryIds=${articlesForCategoryIds?.length ?? 0}, '
      'categoriesCollapsed=$categoriesCollapsed, '
      'contactUsButtonVisible=$contactUsButtonVisible, '
      'showConversationsMenuButton=$showConversationsMenuButton',
    );
    try {
      final String result = await _channel.invokeMethod(
        'help_center',
        arguments,
      );
      _log('helpCenter native result="$result"');
    } catch (e) {
      _logError('helpCenter', e);
      rethrow;
    }
  }

  Future<void> helpCenterWithSectionIds({
    List<int>? articlesForSectionIds,
    bool? categoriesCollapsed,
    bool? contactUsButtonVisible,
    bool? showConversationsMenuButton,
  }) async {
    Map arguments = {
      'articlesForSectionIds': articlesForSectionIds,
      'categoriesCollapsed': categoriesCollapsed,
      'contactUsButtonVisible': contactUsButtonVisible,
      'showConversationsMenuButton': showConversationsMenuButton,
    };

    _log(
      'helpCenterWithSectionIds called: '
      'sectionIds=${articlesForSectionIds?.length ?? 0}, '
      'categoriesCollapsed=$categoriesCollapsed, '
      'contactUsButtonVisible=$contactUsButtonVisible, '
      'showConversationsMenuButton=$showConversationsMenuButton',
    );
    try {
      final String result = await _channel.invokeMethod(
        'help_center_with_section_ids',
        arguments,
      );
      _log('helpCenterWithSectionIds native result="$result"');
    } catch (e) {
      _logError('helpCenterWithSectionIds', e);
      rethrow;
    }
  }

  Future<void> articleWithId(
    String? articleId,
    bool? contactUsButtonVisible,
  ) async {
    Map arguments = {
      'articleId': articleId,
      'contactUsButtonVisible': contactUsButtonVisible,
    };

    _log(
      'articleWithId called: '
      'articleId=${_presence(articleId)}, '
      'contactUsButtonVisible=$contactUsButtonVisible',
    );
    try {
      final String result = await _channel.invokeMethod(
        'article_with_id',
        arguments,
      );
      _log('articleWithId native result="$result"');
    } catch (e) {
      _logError('articleWithId', e);
      rethrow;
    }
  }

  Future<dynamic> changeNavigationBarVisibility(bool isVisible) async {
    _log('changeNavigationBarVisibility called: isVisible=$isVisible');
    try {
      final result = await _channel.invokeMethod(
        'changeNavigationBarVisibility',
        <String, dynamic>{'isVisible': isVisible},
      );
      _log('changeNavigationBarVisibility native result="$result"');
      return result;
    } catch (e) {
      _logError('changeNavigationBarVisibility', e);
      rethrow;
    }
  }
}
