import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:reyhowley/common/models/response_model.dart';
import 'package:reyhowley/features/auth/domain/models/auth_response_model.dart';
import 'package:reyhowley/features/auth/domain/models/signup_body_model.dart';
import 'package:reyhowley/features/auth/domain/models/social_log_in_body.dart';
import 'package:reyhowley/features/auth/domain/reposotories/auth_repository_interface.dart';
import 'package:reyhowley/features/auth/domain/services/auth_service_interface.dart';
import 'package:reyhowley/features/verification/domein/enum/verification_type_enum.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepositoryInterface authRepositoryInterface;
  AuthService({required this.authRepositoryInterface});

  @override
  bool isSharedPrefNotificationActive() {
    return authRepositoryInterface.isSharedPrefNotificationActive();
  }

  @override
  Future<ResponseModel> registration(SignUpBodyModel signUpBody) async {
    // FIREBASE ONLY: Create Firebase user and store data in Firestore
    // Backend API calls are commented out as per user request

    try {
      // Step 1: Create Firebase user
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: signUpBody.email?.trim() ?? '',
            password: signUpBody.password ?? '',
          );

      if (kDebugMode) {
        debugPrint(
          '✅ User registered successfully in Firebase Auth: ${credential.user!.uid}',
        );
      }

      // Step 2: Update display name
      if (signUpBody.name != null && signUpBody.name!.isNotEmpty) {
        await credential.user?.updateDisplayName(signUpBody.name);
      }

      // Step 3: Store user data in Firestore (optional - won't fail registration if Firestore not set up)
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
              'uid': credential.user!.uid,
              'name': signUpBody.name ?? '',
              'fName': signUpBody.fName ?? '',
              'lName': signUpBody.lName ?? '',
              'email': signUpBody.email ?? '',
              'phone': signUpBody.phone ?? '',
              'refCode': signUpBody.refCode ?? '',
              'createdAt': FieldValue.serverTimestamp(),
              'isEmailVerified': false,
              'isPhoneVerified': false,
              'isPersonalInfo': true,
            });

        if (kDebugMode) {
          debugPrint('✅ User data stored in Firestore');
        }
      } on FirebaseException catch (e) {
        // Firestore error - log but don't fail registration
        if (kDebugMode) {
          debugPrint(
            '⚠️ Firestore error (non-critical): ${e.code} - ${e.message}',
          );
          if (e.code == 'not-found') {
            debugPrint(
              '💡 Please create Firestore database in Firebase Console:',
            );
            debugPrint(
              '   https://console.firebase.google.com/project/reyhowley/firestore',
            );
          }
        }
      } catch (e) {
        // Other Firestore errors - log but don't fail registration
        if (kDebugMode) {
          debugPrint('⚠️ Failed to store user in Firestore (non-critical): $e');
        }
      }

      // Create a mock auth response (replacing backend response)
      AuthResponseModel authResponse = AuthResponseModel(
        token: await credential.user!.getIdToken(),
        isPhoneVerified: false,
        isEmailVerified: false,
        isPersonalInfo: true,
      );

      // Save token locally
      authRepositoryInterface.saveUserToken(
        authResponse.token ?? '',
        alreadyInApp: false,
      );

      return ResponseModel(
        true,
        'Registration successful! Welcome to ReyHowley.',
        authResponseModel: authResponse,
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Firebase Auth error: ${e.code} - ${e.message}');
      }

      // Provide user-friendly error messages
      String errorMessage = 'Registration failed.';
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'This email is already registered. Please login instead.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address format.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password is too weak. Please use a stronger password.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Email/password registration is not enabled.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      return ResponseModel(false, errorMessage);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Registration error: $e');
      }
      return ResponseModel(false, 'Registration failed. Please try again.');
    }

    // COMMENTED OUT: Backend API registration
    // try {
    //   Response response = await authRepositoryInterface.registration(
    //     signUpBody,
    //   );
    //   if (response.statusCode == 200) {
    //     AuthResponseModel authResponse = AuthResponseModel.fromJson(
    //       response.body,
    //     );
    //     await _updateHeaderFunctionality(authResponse, alreadyInApp: false);
    //     return ResponseModel(
    //       true,
    //       authResponse.token ?? '',
    //       authResponseModel: authResponse,
    //     );
    //   }
    // } catch (e) {
    //   return ResponseModel(false, e.toString());
    // }
  }

  @override
  Future<ResponseModel> login({
    required String emailOrPhone,
    required String password,
    required String loginType,
    required String fieldType,
    bool alreadyInApp = false,
  }) async {
    // FIREBASE ONLY: Login with Firebase Auth and fetch data from Firestore
    // Backend API calls are commented out as per user request

    if (fieldType == VerificationTypeEnum.phone.name) {
      return ResponseModel(false, 'Please use OTP login for phone numbers.');
    }

    try {
      // Step 1: Sign in with Firebase
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailOrPhone.trim(),
            password: password,
          );

      if (kDebugMode) {
        debugPrint('✅ User logged in successfully: ${credential.user!.uid}');
      }

      // Step 2: Fetch user data from Firestore (optional - won't fail login if not available)
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .get();

        if (kDebugMode) {
          debugPrint('✅ User data fetched from Firestore: ${userDoc.exists}');
        }
      } on FirebaseException catch (e) {
        // Firestore error - log but don't fail login
        if (kDebugMode) {
          debugPrint('⚠️ Firestore fetch error (non-critical): ${e.code}');
        }
      } catch (e) {
        // Other errors - log but don't fail login
        if (kDebugMode) {
          debugPrint(
            '⚠️ Failed to fetch user from Firestore (non-critical): $e',
          );
        }
      }

      // Create a mock auth response (replacing backend response)
      AuthResponseModel authResponse = AuthResponseModel(
        token: await credential.user!.getIdToken(),
        isPhoneVerified: true,
        isEmailVerified: credential.user!.emailVerified,
        isPersonalInfo: true,
      );

      // Save token locally
      authRepositoryInterface.saveUserToken(
        authResponse.token ?? '',
        alreadyInApp: alreadyInApp,
      );
      await authRepositoryInterface.updateToken();
      await authRepositoryInterface.clearSharedPrefGuestId();

      return ResponseModel(
        true,
        'Login successful! Welcome back.',
        authResponseModel: authResponse,
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Firebase Auth error: ${e.code} - ${e.message}');
      }

      // Provide user-friendly error messages
      String errorMessage = 'Login failed.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No account found with this email. Please sign up.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address format.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This account has been disabled.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid email or password. Please check and try again.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many login attempts. Please try again later.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      return ResponseModel(false, errorMessage);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Login error: $e');
      }
      return ResponseModel(false, 'Login failed. Please try again.');
    }

    // COMMENTED OUT: Backend API login
    // try {
    //   Response response = await authRepositoryInterface.login(
    //     emailOrPhone: emailOrPhone,
    //     password: password,
    //     loginType: loginType,
    //     fieldType: fieldType,
    //   );
    //   if (response.statusCode == 200) {
    //     AuthResponseModel authResponse = AuthResponseModel.fromJson(
    //       response.body,
    //     );
    //     await _updateHeaderFunctionality(
    //       authResponse,
    //       alreadyInApp: alreadyInApp,
    //     );
    //     return ResponseModel(
    //       true,
    //       authResponse.token ?? '',
    //       authResponseModel: authResponse,
    //     );
    //   }
    // } catch (e) {
    //   return ResponseModel(false, e.toString());
    // }
  }

  Future<void> _updateHeaderFunctionality(
    AuthResponseModel authResponse, {
    bool alreadyInApp = false,
  }) async {
    if (authResponse.isEmailVerified! &&
        authResponse.isPhoneVerified! &&
        authResponse.isPersonalInfo! &&
        authResponse.token != null &&
        authResponse.isExistUser == null) {
      authRepositoryInterface.saveUserToken(
        authResponse.token ?? '',
        alreadyInApp: alreadyInApp,
      );
      await authRepositoryInterface.updateToken();
      await authRepositoryInterface.clearSharedPrefGuestId();
    }
  }

  @override
  Future<ResponseModel> otpLogin({
    required String phone,
    required String otp,
    required String loginType,
    required String verified,
    bool alreadyInApp = false,
  }) async {
    Response response = await authRepositoryInterface.otpLogin(
      phone: phone,
      otp: otp,
      loginType: loginType,
      verified: verified,
    );
    if (response.statusCode == 200) {
      AuthResponseModel authResponse = AuthResponseModel.fromJson(
        response.body,
      );
      await _updateHeaderFunctionality(
        authResponse,
        alreadyInApp: alreadyInApp,
      );
      return ResponseModel(
        true,
        authResponse.token ?? '',
        authResponseModel: authResponse,
      );
    } else {
      return ResponseModel(false, response.statusText ?? 'OTP login failed.');
    }
  }

  @override
  Future<ResponseModel> guestLogin() async {
    return await authRepositoryInterface.guestLogin();
  }

  @override
  Future<ResponseModel> loginWithSocialMedia(
    SocialLogInBody socialLogInModel, {
    bool isCustomerVerificationOn = false,
  }) async {
    // COMMENTED OUT: Backend API social login
    // Social login now handled by Firebase Auth directly in auth_controller
    if (kDebugMode) {
      debugPrint('⚠️ Social login should be handled by Firebase Auth directly');
    }
    return ResponseModel(false, 'Please use Firebase Auth for social login');

    // COMMENTED OUT: Backend API calls
    // try {
    //   Response response = await authRepositoryInterface.loginWithSocialMedia(
    //     socialLogInModel,
    //   );
    //   if (response.statusCode == 200) {
    //     AuthResponseModel authResponse = AuthResponseModel.fromJson(
    //       response.body,
    //     );
    //     await _updateHeaderFunctionality(authResponse);
    //     return ResponseModel(
    //       true,
    //       authResponse.token ?? '',
    //       authResponseModel: authResponse,
    //     );
    //   } else {
    //     return ResponseModel(
    //       false,
    //       response.statusText ?? 'Social login failed.',
    //     );
    //   }
    // } catch (e) {
    //   return ResponseModel(false, e.toString());
    // }
  }

  @override
  Future<ResponseModel> loginWithFirebaseUser(
    User user, {
    String? loginType,
    bool alreadyInApp = false,
  }) async {
    try {
      // Get Firebase ID token to use as the token for social login with backend
      String? firebaseIdToken = await user.getIdToken();
      if (kDebugMode) {
        debugPrint('Firebase login type: $loginType, uid: ${user.uid}');
      }

      // Call the backend social login endpoint which accepts Firebase tokens
      SocialLogInBody socialLogInBody = SocialLogInBody(
        token: firebaseIdToken,
        email: user.email,
        uniqueId: user.uid,
        medium: loginType ?? 'google',
        loginType: 'social',
      );

      Response response = await authRepositoryInterface.loginWithSocialMedia(
        socialLogInBody,
      );
      if (response.statusCode == 200) {
        AuthResponseModel authResponse = AuthResponseModel.fromJson(
          response.body,
        );
        await _updateHeaderFunctionality(
          authResponse,
          alreadyInApp: alreadyInApp,
        );
        return ResponseModel(
          true,
          authResponse.token ?? '',
          authResponseModel: authResponse,
        );
      } else {
        return ResponseModel(false, response.statusText ?? 'Login failed.');
      }
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  @override
  Future<ResponseModel> updatePersonalInfo({
    required String name,
    required String? phone,
    required String loginType,
    required String? email,
    required String? referCode,
    bool alreadyInApp = false,
  }) async {
    Response response = await authRepositoryInterface.updatePersonalInfo(
      name: name,
      phone: phone,
      email: email,
      loginType: loginType,
      referCode: referCode,
    );
    if (response.statusCode == 200) {
      AuthResponseModel authResponse = AuthResponseModel.fromJson(
        response.body,
      );
      await _updateHeaderFunctionality(
        authResponse,
        alreadyInApp: alreadyInApp,
      );
      return ResponseModel(
        true,
        authResponse.token ?? '',
        authResponseModel: authResponse,
      );
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<void> updateToken() async {
    await authRepositoryInterface.updateToken();
  }

  @override
  bool isLoggedIn() {
    return authRepositoryInterface.isLoggedIn();
  }

  @override
  bool isGuestLoggedIn() {
    return authRepositoryInterface.isGuestLoggedIn();
  }

  @override
  String getSharedPrefGuestId() {
    return authRepositoryInterface.getSharedPrefGuestId();
  }

  @override
  Future<bool> clearSharedData({bool removeToken = true}) async {
    return await authRepositoryInterface.clearSharedData(
      removeToken: removeToken,
    );
  }

  @override
  Future<bool> clearSharedAddress() async {
    return await authRepositoryInterface.clearSharedAddress();
  }

  @override
  Future<void> saveUserNumberAndPassword(
    String number,
    String password,
    String countryCode,
  ) async {
    await authRepositoryInterface.saveUserNumberAndPassword(
      number,
      password,
      countryCode,
    );
  }

  @override
  String getUserNumber() {
    return authRepositoryInterface.getUserNumber();
  }

  @override
  String getUserCountryCode() {
    return authRepositoryInterface.getUserCountryCode();
  }

  @override
  String getUserPassword() {
    return authRepositoryInterface.getUserPassword();
  }

  @override
  Future<bool> clearUserNumberAndPassword() async {
    return await authRepositoryInterface.clearUserNumberAndPassword();
  }

  @override
  String getUserToken() {
    return authRepositoryInterface.getUserToken();
  }

  @override
  Future updateZone() async {
    await authRepositoryInterface.updateZone();
  }

  @override
  Future<bool> saveGuestContactNumber(String number) async {
    return authRepositoryInterface.saveGuestContactNumber(number);
  }

  @override
  String getGuestContactNumber() {
    return authRepositoryInterface.getGuestContactNumber();
  }

  @override
  Future<bool> saveDmTipIndex(String index) async {
    return await authRepositoryInterface.saveDmTipIndex(index);
  }

  @override
  String getDmTipIndex() {
    return authRepositoryInterface.getDmTipIndex();
  }

  @override
  Future<bool> saveEarningPoint(String point) async {
    return await authRepositoryInterface.saveEarningPoint(point);
  }

  @override
  String getEarningPint() {
    return authRepositoryInterface.getEarningPint();
  }

  @override
  Future<void> setNotificationActive(bool isActive) async {
    await authRepositoryInterface.setNotificationActive(isActive);
  }

  @override
  Future<String?> saveDeviceToken() async {
    return await authRepositoryInterface.saveDeviceToken();
  }
}
