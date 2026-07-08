import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/services/device_info_service.dart';

class DeviceInfoRepository {
  final _deviceInfoRepo = getIt<DeviceInfoService>();

  Future<String> getDeviceInfoPlatform() async {
    Map<String, dynamic> deviceInfo = await _deviceInfoRepo.getDeviceInfo();
    return deviceInfo['platform'];
  }
}
