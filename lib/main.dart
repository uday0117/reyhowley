import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';
import 'package:reyhowley/common/controllers/theme_controller.dart';
import 'package:reyhowley/features/auth/controllers/auth_controller.dart';
import 'package:reyhowley/features/cart/controllers/cart_controller.dart';
import 'package:reyhowley/features/home/widgets/cookies_view.dart';
import 'package:reyhowley/features/language/controllers/language_controller.dart';
import 'package:reyhowley/features/notification/domain/models/notification_body_model.dart';
import 'package:reyhowley/features/splash/controllers/splash_controller.dart';
import 'package:reyhowley/helper/address_helper.dart';
import 'package:reyhowley/helper/auth_helper.dart';
import 'package:reyhowley/helper/notification_helper.dart';
import 'package:reyhowley/helper/responsive_helper.dart';
import 'package:reyhowley/helper/route_helper.dart';
import 'package:reyhowley/theme/dark_theme.dart';
import 'package:reyhowley/theme/light_theme.dart';
import 'package:reyhowley/util/app_constants.dart';
import 'package:reyhowley/util/messages.dart';

import 'firebase_options.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  /// ✅ SINGLE, CORRECT Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Map<String, Map<String, String>> languages = await di.init();

  NotificationBodyModel? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage = await FirebaseMessaging.instance
          .getInitialMessage();

      if (remoteMessage != null) {
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }

      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);

      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (_) {}

  /// Facebook Web init
  if (ResponsiveHelper.isWeb()) {
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "380903914182154",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }

  runApp(MyApp(languages: languages, body: body));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBodyModel? body;

  const MyApp({super.key, required this.languages, required this.body});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  void _route() async {
    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();

      if (AddressHelper.getUserAddressFromSharedPref() != null &&
          AddressHelper.getUserAddressFromSharedPref()!.zoneIds == null) {
        Get.find<AuthController>().clearSharedAddress();
      }

      if (!AuthHelper.isLoggedIn() && !AuthHelper.isGuestLoggedIn()) {
        await Get.find<AuthController>().guestLogin();
      }

      if ((AuthHelper.isLoggedIn() || AuthHelper.isGuestLoggedIn()) &&
          Get.find<SplashController>().cacheModule != null) {
        Get.find<CartController>().getCartDataOnline();
      }

      Get.find<SplashController>().getConfigData(
        loadLandingData:
            (GetPlatform.isWeb &&
            AddressHelper.getUserAddressFromSharedPref() == null),
        fromMainFunction: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      id: 'theme-builder',
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          id: 'locale-builder',
          builder: (localizeController) {
            return GetBuilder<SplashController>(
              id: 'splash-builder',
              builder: (splashController) {
                // Prevent rendering until web config is ready
                if (GetPlatform.isWeb && splashController.configModel == null) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: Container(
                      color: Colors.white,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                return GetMaterialApp(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: Get.key,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                    },
                  ),
                  theme: themeController.darkTheme ? dark() : light(),
                  locale: localizeController.locale,
                  translations: Messages(languages: widget.languages),
                  fallbackLocale: Locale(
                    AppConstants.languages[0].languageCode!,
                    AppConstants.languages[0].countryCode,
                  ),
                  initialRoute: GetPlatform.isWeb
                      ? RouteHelper.getInitialRoute()
                      : RouteHelper.getSplashRoute(widget.body),
                  getPages: RouteHelper.routes,
                  defaultTransition: Transition.topLevel,
                  transitionDuration: const Duration(milliseconds: 500),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(textScaler: const TextScaler.linear(1)),
                      child: Material(
                        child: SafeArea(
                          top: false,
                          bottom: GetPlatform.isAndroid,
                          child: Stack(
                            children: [
                              child!,
                              GetBuilder<SplashController>(
                                id: 'cookies-builder',
                                builder: (cookieController) {
                                  if (!cookieController.savedCookiesData &&
                                      !cookieController.getAcceptCookiesStatus(
                                        cookieController.configModel != null
                                            ? cookieController
                                                  .configModel!
                                                  .cookiesText!
                                            : '',
                                      )) {
                                    return ResponsiveHelper.isWeb()
                                        ? const Align(
                                            alignment: Alignment.bottomCenter,
                                            child: CookiesView(),
                                          )
                                        : const SizedBox();
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
