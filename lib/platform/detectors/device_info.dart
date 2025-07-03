import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:platform/platform.dart';
import 'package:flutter/services.dart';

class DeviceInfo {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        return _parseWebDeviceInfo(webInfo);
      } else if (const LocalPlatform().isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return _parseAndroidDeviceInfo(androidInfo);
      } else if (const LocalPlatform().isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return _parseIOSDeviceInfo(iosInfo);
      }
      return {};
    } on PlatformException catch (e) {
      throw Exception(
        'Error al obtener información del dispositivo: ${e.message}',
      );
    }
  }

  Map<String, dynamic> _parseWebDeviceInfo(WebBrowserInfo info) {
    return {
      'browserName': info.browserName.name,
      'appVersion': info.appVersion,
      'platform': info.platform,
      'userAgent': info.userAgent,
      'deviceMemory': info.deviceMemory,
      'languages': info.languages,
    };
  }

  Map<String, dynamic> _parseAndroidDeviceInfo(AndroidDeviceInfo info) {
    return {
      'model': info.model,
      'brand': info.brand,
      'manufacturer': info.manufacturer,
      'version': info.version.release,
      'sdkInt': info.version.sdkInt,
      'isPhysicalDevice': info.isPhysicalDevice,
    };
  }

  Map<String, dynamic> _parseIOSDeviceInfo(IosDeviceInfo info) {
    return {
      'name': info.name,
      'systemName': info.systemName,
      'systemVersion': info.systemVersion,
      'model': info.model,
      'isPhysicalDevice': info.isPhysicalDevice,
    };
  }
}
