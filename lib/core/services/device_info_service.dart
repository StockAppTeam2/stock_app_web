import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  Future<Map<String, dynamic>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final webInfo = await deviceInfoPlugin.webBrowserInfo;
    print(webInfo.browserName); // chrome, firefox, safari, edge
    print(webInfo.userAgent); // Full browser user agent
    print(webInfo.platform); // Platform
    print(webInfo.vendor); // Browser vendor
    print(webInfo.language); // Browser language
    print(webInfo.hardwareConcurrency); // CPU cores
    print(webInfo.maxTouchPoints); // Touch support
    print(webInfo.deviceMemory); // RAM (if browser supports)
    return {
      'browserName': webInfo.browserName,
      'userAgent': webInfo.userAgent,
      'platform': webInfo.platform,
      'vendor': webInfo.vendor,
      'language': webInfo.language,
      'hardwareConcurrency': webInfo.hardwareConcurrency,
      'maxTouchPoints': webInfo.maxTouchPoints,
      'deviceMemory': webInfo.deviceMemory,
      'appCodeName': webInfo.appCodeName,
      'appName': webInfo.appName,
      'appVersion': webInfo.appVersion,
      'product': webInfo.product,
      'productSub': webInfo.productSub,
      'vendorSub': webInfo.vendorSub,
      'languages': webInfo.languages,
      'data': webInfo.data,
    };
  }
}
