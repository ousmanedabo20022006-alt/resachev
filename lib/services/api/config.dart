import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;

class AppConfig {
  static late final String apiBaseUrl;
  static late final String appVersion;

  static Future<void> load() async {
    final jsonString =
    await rootBundle.loadString('assets/env.dev.json');

    final Map<String, dynamic> config =
    jsonDecode(jsonString);

    if (kIsWeb) {
      apiBaseUrl = config['API_URL_WEB'];
    } else if (Platform.isAndroid) {
      apiBaseUrl = config['API_URL_ANDROID'];
    } else if (Platform.isIOS) {
      apiBaseUrl = config['API_URL_IOS'];
    } else if (Platform.isWindows ||
        Platform.isLinux ||
        Platform.isMacOS) {
      apiBaseUrl =
          config['API_URL_DESKTOP'] ??
              config['API_URL_WEB'];
    } else {
      apiBaseUrl =
          config['API_URL_WEB'] ??
              'http://localhost:8000/api';
    }

    appVersion =
        config['APP_VERSION'] ?? '1.0.0';
  }
}