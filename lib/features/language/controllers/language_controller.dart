import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reyhowley/features/home/screens/home_screen.dart';
import 'package:reyhowley/features/language/domain/models/language_model.dart';
import 'package:reyhowley/features/language/domain/service/language_service_interface.dart';
import 'package:reyhowley/features/splash/controllers/splash_controller.dart';
import 'package:reyhowley/helper/address_helper.dart';
import 'package:reyhowley/helper/responsive_helper.dart';
import 'package:reyhowley/util/app_constants.dart';

class LocalizationController extends GetxController implements GetxService {
  final LanguageServiceInterface languageServiceInterface;
  LocalizationController({required this.languageServiceInterface}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(
    AppConstants.languages[0].languageCode!,
    AppConstants.languages[0].countryCode,
  );
  Locale get locale => _locale;

  bool _isLtr = true;
  bool get isLtr => _isLtr;

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  int _selectedLanguageIndex = 0;
  int get selectedLanguageIndex => _selectedLanguageIndex;

  void setLanguage(Locale locale, {bool fromBottomSheet = false}) {
    Get.updateLocale(locale);
    _locale = locale;
    _isLtr = languageServiceInterface.setLTR(_locale);
    languageServiceInterface.updateHeader(
      _locale,
      Get.find<SplashController>().module?.id,
    );

    if (!fromBottomSheet) {
      saveLanguage(_locale);
    }

    if (AddressHelper.getUserAddressFromSharedPref() != null &&
        !fromBottomSheet) {
      HomeScreen.loadData(true);
    } else if (ResponsiveHelper.isDesktop(Get.context) &&
        AddressHelper.getUserAddressFromSharedPref() == null) {
      Get.find<SplashController>().getLandingPageData();
    }

    if (Get.find<SplashController>().moduleList == null) {
      Get.find<SplashController>().getModules(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          AppConstants.localizationKey:
              Get.find<LocalizationController>().locale.languageCode,
        },
      );
    }

    // update(['locale-builder']);
    update();

  }

  void loadCurrentLanguage() async {
    _locale = languageServiceInterface.getLocaleFromSharedPref();
    _isLtr = _locale.languageCode != 'ar';
    _selectedLanguageIndex = languageServiceInterface.setSelectedIndex(
      AppConstants.languages,
      _locale,
    );
    _languages = [];
    _languages.addAll(AppConstants.languages);
    // update(['locale-builder']);
    update();

  }

  void saveLanguage(Locale locale) async {
    languageServiceInterface.saveLanguage(locale);
  }

  void saveCacheLanguage(Locale? locale) {
    languageServiceInterface.saveCacheLanguage(
      locale ?? languageServiceInterface.getLocaleFromSharedPref(),
    );
  }

  void setSelectLanguageIndex(int index) {
    _selectedLanguageIndex = index;
    // update(['locale-builder']);
    update();

  }

  Locale getCacheLocaleFromSharedPref() {
    return languageServiceInterface.getCacheLocaleFromSharedPref();
  }

  void searchSelectedLanguage() {
    _selectedLanguageIndex = AppConstants.languages.indexWhere(
      (language) =>
          language.languageCode == _locale.languageCode &&
          language.countryCode == _locale.countryCode,
    );
  }
}
