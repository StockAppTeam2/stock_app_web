import 'package:stock_app_web/core/constants/web_version.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/device_info_repository.dart';
import 'package:stock_app_web/core/repositories/user_repository.dart';
import 'package:intl/intl.dart';

enum LoginStatus { success, userNotFound, invalidPassword }

class LoginPageController {
  final _userRepo = getIt<UserRepository>();
  final _deviceInfoRepo = getIt<DeviceInfoRepository>();

  Future<LoginStatus> login(String mobile, String password) async {
    final user = await _userRepo.checkUserPresent(mobile);

    if (user == null) {
      return LoginStatus.userNotFound;
    }

    if (user.password != password) {
      return LoginStatus.invalidPassword;
    }

    return LoginStatus.success;
  }

  Future<bool> verifyUser(String mobile) async {
    final user = await _userRepo.checkUserPresent(mobile);
    if (user == null) {
      return false;
    }
    return true;
  }

  Future<void> addNewUser(
    String mobile,
    String shopNumber,
    String place,
  ) async {
    DateTime date = DateTime.now();

    DateTime nextMonth = DateTime(date.year, date.month + 1, 1);
    DateTime lastDayOfMonth = nextMonth.subtract(const Duration(days: 1));
    DateTime targetDate = lastDayOfMonth.add(
      const Duration(hours: 23, minutes: 59),
    );
    String firstOpDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    String lastUpdated = '${date.toString().substring(0, 10)} $date';
    String devicePlatform = await _deviceInfoRepo.getDeviceInfoPlatform();

    await _userRepo.createUser({
      'mobileNumber': mobile,
      'isManager': true,
      'isVerified': true,
      'shopId': shopNumber,
      'isPresent': true,
      'isInCharge': true,
      'accessExpireAt': '',
      'device': devicePlatform,
      'version': webVersion,
    });

    await _userRepo.createAuthUser({
      'mobileNumber': mobile,
      'code': '000000',
      'date': date,
      'isManager': true,
      'isVerified': true,
      'password': '123456',
      'isPasswordChanged': false,
    });

    await _userRepo.createOffice({
      'shopId': shopNumber,
      'salesManager': mobile,
      'salesMan': [],
      'defaultFilter': [],
      'isAllowAll': true,
      'isAnyUserInCharge': false,
      'district': place,
    });

    await _userRepo.salesAdjustment({
      'shopId': shopNumber,
      'lastDateOfMonth': targetDate,
      'salesAdjustment': 0,
      'imflSalesCumulativeCaseAdjustment': 0,
      'beerSalesCumulativeCaseAdjustment': 0,
      'firstOpDate': firstOpDate,
      'openingAdjustment': 0,
      'receiptAdjustment': 0,
      'closingAdjustment': 0,
    });

    await _userRepo.createSettings({
      'shopId': shopNumber,
      'isOpeningExist': true,
      'isOpeningExistPdf': false,
      'isPaid': true,
      'isDemo': true,
      'closingPdfFormat': 'default',
      'smsFormat': 'ERODENEW',
      'posFormat': 'ERODENEW',
      'shopType': 'Regular',
      'sampleDataPresent': true,
    });

    await _userRepo.createMaster({'shopId': shopNumber});

    // bool newMastersCreated =

    await _userRepo.createMastersBrands(shopNumber, "E2E");

    // if (newMastersCreated) {}

    await _userRepo.createSampleData(
      shopNumber,
      date.toString().substring(0, 10),
    );

    Map<String, dynamic> itemData = {
      'itemsLastDate': lastUpdated,
      'itemsOneDayBeforeDate': lastUpdated,
      'shopId': shopNumber,
      'isClosingComplete': true,
      'EnterSales': true,
    };
    Map<String, dynamic> inwardData = {
      'inwardLastDate': lastUpdated,
      'inwardOneDayBeforeDate': lastUpdated,
      'shopId': shopNumber,
    };
    Map<String, dynamic> salesData = {
      'salesLastDate': lastUpdated,
      'salesOneDayBeforeDate': lastUpdated,
      'shopId': shopNumber,
    };
    Map<String, dynamic> posData = {
      'posLastDate': lastUpdated,
      'posOneDayBeforeDate': lastUpdated,
      'shopId': shopNumber,
    };

    await _userRepo.createLastUpdateDates(
      shopNumber,
      itemData,
      inwardData,
      salesData,
      posData,
    );
  }
}
