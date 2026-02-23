import 'dart:async';

import 'package:get/get.dart';
import 'package:reyhowley/features/home/domain/models/cashback_model.dart';
import 'package:reyhowley/features/home/domain/services/home_service_interface.dart';

class HomeController extends GetxController implements GetxService {
  final HomeServiceInterface homeServiceInterface;
  HomeController({required this.homeServiceInterface});

  List<CashBackModel>? _cashBackOfferList;
  List<CashBackModel>? get cashBackOfferList => _cashBackOfferList;

  CashBackModel? _cashBackData;
  CashBackModel? get cashBackData => _cashBackData;

  bool _showFavButton = true;
  bool get showFavButton => _showFavButton;

  // Add loading state to prevent multiple simultaneous API calls
  bool _isLoadingHomeData = false;
  bool get isLoadingHomeData => _isLoadingHomeData;

  DateTime? _lastLoadTime;

  void setLoadingHomeData(bool loading) {
    _isLoadingHomeData = loading;
    update();
  }

  bool shouldLoadHomeData() {
    // Prevent loading if already loading
    if (_isLoadingHomeData) {
      return false;
    }

    // Debounce: prevent loading if last load was less than 3 seconds ago
    if (_lastLoadTime != null) {
      final difference = DateTime.now().difference(_lastLoadTime!);
      if (difference.inSeconds < 3) {
        return false;
      }
    }

    return true;
  }

  void markHomeDataLoaded() {
    _lastLoadTime = DateTime.now();
    _isLoadingHomeData = false;
  }

  Future<void> getCashBackOfferList() async {
    _cashBackOfferList = null;
    _cashBackOfferList = await homeServiceInterface.getCashBackOfferList();
    update();
  }

  void forcefullyNullCashBackOffers() {
    _cashBackOfferList = null;
    update();
  }

  Future<void> getCashBackData(double amount) async {
    CashBackModel? cashBackModel = await homeServiceInterface.getCashBackData(
      amount,
    );
    if (cashBackModel != null) {
      _cashBackData = cashBackModel;
    }
    update();
  }

  void changeFavVisibility() {
    _showFavButton = !_showFavButton;
    update();
  }

  Future<bool> saveRegistrationSuccessfulSharedPref(bool status) async {
    return await homeServiceInterface.saveRegistrationSuccessful(status);
  }

  Future<bool> saveIsStoreRegistrationSharedPref(bool status) async {
    return await homeServiceInterface.saveIsRestaurantRegistration(status);
  }

  bool getRegistrationSuccessfulSharedPref() {
    return homeServiceInterface.getRegistrationSuccessful();
  }

  bool getIsStoreRegistrationSharedPref() {
    return homeServiceInterface.getIsRestaurantRegistration();
  }
}
