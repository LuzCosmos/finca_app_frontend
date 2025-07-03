import 'package:flutter/foundation.dart';
import 'package:platform/platform.dart';

class PlatformDetector {
  static final Platform _platform = const LocalPlatform();

  static bool isWeb() => kIsWeb;
  static bool isMobile() => !kIsWeb;
  static bool isAndroid() => _platform.isAndroid;
  static bool isIOS() => _platform.isIOS;

  static String getOSVersion() {
    if (isWeb()) {
      return 'Web';
    } else if (isAndroid()) {
      return 'Android ${_platform.operatingSystemVersion}';
    } else if (isIOS()) {
      return 'iOS ${_platform.operatingSystemVersion}';
    }
    return _platform.operatingSystemVersion;
  }

  static Map<String, dynamic> getDeviceInfo() {
    return {
      'platform': _platform.operatingSystem,
      'version': _platform.operatingSystemVersion,
      'pathSeparator': _platform.pathSeparator,
    };
  }
}
