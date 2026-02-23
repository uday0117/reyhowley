import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:reyhowley/api/api_client.dart';
import 'package:reyhowley/common/models/response_model.dart';
import 'package:reyhowley/features/auth/controllers/auth_controller.dart';
import 'package:reyhowley/features/auth/domain/models/auth_response_model.dart';
import 'package:reyhowley/features/verification/domein/models/verification_data_model.dart';
import 'package:reyhowley/features/verification/domein/reposotories/verification_repository_interface.dart';
import 'package:reyhowley/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationRepository implements VerificationRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  VerificationRepository({
    required this.sharedPreferences,
    required this.apiClient,
  });

  @override
  Future<ResponseModel> forgetPassword({String? phone, String? email}) async {
    String? deviceToken = await Get.find<AuthController>().saveDeviceToken();
    Response response = await apiClient
        .postData(AppConstants.forgetPasswordUri, {
          "phone": phone,
          "email": email,
          "verification_method": phone != null && phone.isNotEmpty
              ? 'phone'
              : 'email',
          "cm_firebase_token": deviceToken!,
        }, handleError: false);
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> resetPassword({
    String? resetToken,
    String? phone,
    String? email,
    required String password,
    required String confirmPassword,
  }) async {
    Response response = await apiClient
        .postData(AppConstants.resetPasswordUri, {
          "_method": "put",
          "reset_token": resetToken,
          "phone": phone != null && phone != 'null' && phone.isNotEmpty
              ? phone
              : '',
          "email": email != null && email != 'null' && email.isNotEmpty
              ? email
              : '',
          "verification_method":
              phone != null && phone != 'null' && phone.isNotEmpty
              ? 'phone'
              : 'email',
          "password": password,
          "confirm_password": confirmPassword,
        }, handleError: false);
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<Response> verifyPhone(VerificationDataModel data) async {
    return await apiClient.postData(
      AppConstants.verifyPhoneUri,
      data.toJson(),
      handleError: false,
    );
  }

  @override
  Future<ResponseModel> verifyFirebaseOtp({
    required String phoneNumber,
    required String session,
    required String otp,
    required String loginType,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: session,
        smsCode: otp,
      );
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      User? user = userCredential.user;
      if (user == null) {
        return ResponseModel(false, 'OTP verification failed.');
      }
      String token = await user.getIdToken() ?? '';
      AuthResponseModel authResponse = AuthResponseModel(
        token: token,
        isPhoneVerified: true,
        isEmailVerified: true,
        isPersonalInfo: true,
        loginType: loginType,
        email: user.email,
      );
      return ResponseModel(true, 'Verified', authResponseModel: authResponse);
    } on FirebaseAuthException catch (e) {
      return ResponseModel(false, e.message ?? 'OTP verification failed.');
    }
  }

  @override
  Future<ResponseModel> verifyForgetPassFirebaseOtp({
    required String phoneNumber,
    required String session,
    required String otp,
  }) async {
    Response response = await apiClient
        .postData(AppConstants.firebaseResetPassword, {
          'sessionInfo': session,
          'phoneNumber': phoneNumber,
          'code': otp,
          'is_reset_token': 1,
          '_method': 'PUT',
        });
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> verifyToken({
    String? phone,
    String? email,
    required String token,
  }) async {
    Response response = await apiClient.postData(AppConstants.verifyTokenUri, {
      "phone": phone,
      "email": email,
      "verification_method": phone != null && phone.isNotEmpty
          ? 'phone'
          : 'email',
      "reset_token": token,
    });
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
