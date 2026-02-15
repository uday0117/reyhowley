import 'dart:convert';

import 'package:get/get.dart';
import 'package:reyhowley/common/models/module_model.dart';
import 'package:reyhowley/features/address/domain/models/address_model.dart';
import 'package:reyhowley/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderHelper {
  static Map<String, String> featuredHeader() {
    SharedPreferences sharedPreferences = Get.find<SharedPreferences>();
    AddressModel? addressModel;
    try {
      String? addressString = sharedPreferences.getString(
        AppConstants.userAddress,
      );
      if (addressString != null) {
        addressModel = AddressModel.fromJson(jsonDecode(addressString));
      }
    } catch (_) {}
    int? moduleID;
    if (GetPlatform.isWeb &&
        sharedPreferences.containsKey(AppConstants.moduleId)) {
      try {
        String? moduleString = sharedPreferences.getString(
          AppConstants.moduleId,
        );
        if (moduleString != null) {
          moduleID = ModuleModel.fromJson(jsonDecode(moduleString)).id;
        }
      } catch (_) {}
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      AppConstants.zoneId: addressModel?.zoneIds != null
          ? jsonEncode(addressModel?.zoneIds)
          : '',
      moduleID != null ? AppConstants.moduleId : '$moduleID': '',
      AppConstants.localizationKey:
          sharedPreferences.getString(AppConstants.languageCode) ??
          AppConstants.languages[0].languageCode!,
      AppConstants.latitude: addressModel?.latitude != null
          ? jsonEncode(addressModel?.latitude)
          : '',
      AppConstants.longitude: addressModel?.longitude != null
          ? jsonEncode(addressModel?.longitude)
          : '',
      // 'Authorization': 'Bearer $token'
    };
  }
}
