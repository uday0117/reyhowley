import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reyhowley/common/models/response_model.dart';
import 'package:reyhowley/common/widgets/custom_snackbar.dart';
import 'package:reyhowley/features/profile/domain/models/update_user_model.dart';
import 'package:reyhowley/features/profile/domain/models/userinfo_model.dart';
import 'package:reyhowley/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:reyhowley/features/profile/domain/services/profile_service_interface.dart';

class ProfileService implements ProfileServiceInterface {
  final ProfileRepositoryInterface profileRepositoryInterface;
  ProfileService({required this.profileRepositoryInterface});

  @override
  Future<UserInfoModel?> getUserInfo() async {
    // Try to get user data from Firestore first (Firebase-only authentication)
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        print(
          '✅ Loading user profile from Firestore for UID: ${firebaseUser.uid}',
        );

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          // Convert Firestore data to UserInfoModel
          UserInfoModel userInfo = UserInfoModel(
            id: int.tryParse(firebaseUser.uid.hashCode.toString()),
            fName: userData['f_name'] ?? userData['firstName'] ?? '',
            lName: userData['l_name'] ?? userData['lastName'] ?? '',
            email: userData['email'] ?? firebaseUser.email ?? '',
            phone: userData['phone'] ?? firebaseUser.phoneNumber ?? '',
            imageFullUrl: userData['image'] ?? userData['image_full_url'],
            createdAt:
                userData['created_at'] ?? DateTime.now().toIso8601String(),
            orderCount: userData['order_count'] ?? 0,
            memberSinceDays: _calculateMemberSinceDays(userData['created_at']),
            walletBalance: (userData['wallet_balance'] ?? 0.0).toDouble(),
            loyaltyPoint: userData['loyalty_point'] ?? 0,
            refCode: userData['ref_code'],
            isPhoneVerified: firebaseUser.phoneNumber != null,
            isEmailVerified: firebaseUser.emailVerified,
          );

          print('✅ User profile loaded from Firestore successfully');
          print('   Name: ${userInfo.fName} ${userInfo.lName}');
          print('   Email: ${userInfo.email}');
          print('   Phone: ${userInfo.phone}');
          return userInfo;
        } else {
          print(
            '⚠️  User document not found in Firestore, creating default profile',
          );
          // Create a basic user profile from Firebase Auth data
          UserInfoModel userInfo = UserInfoModel(
            id: int.tryParse(firebaseUser.uid.hashCode.toString()),
            fName: firebaseUser.displayName?.split(' ').first ?? 'User',
            lName: firebaseUser.displayName?.split(' ').skip(1).join(' ') ?? '',
            email: firebaseUser.email ?? '',
            phone: firebaseUser.phoneNumber ?? '',
            imageFullUrl: firebaseUser.photoURL,
            createdAt: DateTime.now().toIso8601String(),
            orderCount: 0,
            memberSinceDays: 0,
            walletBalance: 0.0,
            loyaltyPoint: 0,
            isPhoneVerified: firebaseUser.phoneNumber != null,
            isEmailVerified: firebaseUser.emailVerified,
          );
          return userInfo;
        }
      }
    } catch (e) {
      print('❌ Error loading user profile from Firestore: $e');
    }

    // Fallback to backend API (will likely fail with 500)
    print('⚠️  Attempting to load user profile from backend API...');
    return await profileRepositoryInterface.get(null);
  }

  int _calculateMemberSinceDays(String? createdAt) {
    if (createdAt == null) return 0;
    try {
      DateTime created = DateTime.parse(createdAt);
      return DateTime.now().difference(created).inDays;
    } catch (e) {
      return 0;
    }
  }

  /*  @override
  Future<ResponseModel> updateProfile(UserInfoModel userInfoModel, XFile? data, String token) async {
    return await profileRepositoryInterface.updateProfile(userInfoModel, data, token);
  }*/

  @override
  Future<ResponseModel> updateProfile(
    UpdateUserModel userInfoModel,
    XFile? data,
    String token,
  ) async {
    // Update Firestore first (Firebase-only authentication)
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        print(
          '✅ Updating user profile in Firestore for UID: ${firebaseUser.uid}',
        );

        // Parse name into first and last name
        String fullName = userInfoModel.name ?? '';
        List<String> nameParts = fullName.trim().split(' ');
        String firstName = nameParts.isNotEmpty ? nameParts.first : '';
        String lastName = nameParts.length > 1
            ? nameParts.skip(1).join(' ')
            : '';

        Map<String, dynamic> updateData = {
          'f_name': firstName,
          'firstName': firstName,
          'l_name': lastName,
          'lastName': lastName,
          'email': userInfoModel.email ?? '',
          'phone': userInfoModel.phone ?? '',
          'updated_at': DateTime.now().toIso8601String(),
        };

        // Upload profile image to Firebase Storage if provided
        if (data != null) {
          try {
            print('📤 Uploading profile image to Firebase Storage...');

            final String fileName =
                'profile_${firebaseUser.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
            final Reference storageRef = FirebaseStorage.instance
                .ref()
                .child('user_profiles')
                .child(fileName);

            // Upload the file
            final File imageFile = File(data.path);
            final UploadTask uploadTask = storageRef.putFile(imageFile);
            final TaskSnapshot snapshot = await uploadTask;

            // Get download URL
            final String downloadUrl = await snapshot.ref.getDownloadURL();
            updateData['image'] = downloadUrl;
            updateData['image_full_url'] = downloadUrl;

            print('✅ Profile image uploaded successfully: $downloadUrl');
          } catch (e) {
            print('❌ Error uploading profile image: $e');
            // Continue with profile update even if image upload fails
          }
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set(updateData, SetOptions(merge: true));

        print('✅ User profile updated in Firestore successfully');
        print('   Name: $firstName $lastName');
        print('   Email: ${userInfoModel.email}');
        print('   Phone: ${userInfoModel.phone}');

        // Refresh user info after update
        await getUserInfo();

        return ResponseModel(true, 'profile_updated_successfully'.tr);
      }
    } catch (e) {
      print('❌ Error updating user profile in Firestore: $e');
    }

    // Fallback to backend API (will likely fail with 500)
    return await profileRepositoryInterface.updateProfile(
      userInfoModel,
      data,
      token,
    );
  }

  @override
  Future<ResponseModel> changePassword(UserInfoModel userInfoModel) async {
    return await profileRepositoryInterface.changePassword(userInfoModel);
  }

  @override
  Future<Response> deleteUser() async {
    return await profileRepositoryInterface.delete(null);
  }

  @override
  Future<XFile?> pickImageFromGallery() async {
    XFile? pickedFile;
    XFile? pickLogo = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickLogo != null) {
      await pickLogo.length().then((value) {
        if (value > 1000000) {
          showCustomSnackBar('please_upload_lower_size_file'.tr);
        } else {
          pickedFile = pickLogo;
        }
      });
    }
    return pickedFile;
  }
}
