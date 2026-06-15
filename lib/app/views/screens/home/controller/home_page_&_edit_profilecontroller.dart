import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:saymymeds/app/core/consants/api_constants.dart';
import 'dart:convert';
import 'package:saymymeds/app/utlies/storage_helper.dart';
import 'package:flutter/material.dart';

class HomePageEditProfilecontroller extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var image = ''.obs;
  var isLoading = false.obs;
  var preferredLanguage = 'en'.obs;

  final String baseUrl = ApiConstants.baseUrl;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // ✅ Fetch profile data from API
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      String? token = await StorageHelper.getToken();

      if (token == null) {
        print("❌ No token found");
        return;
      }

      print("🔑 Token: ${token.substring(0, token.length > 50 ? 50 : token.length)}...");

      var headers = {'Authorization': 'Bearer $token'};

      // ✅ সঠিক URL - ApiConstants.userProfile (এটা কাজ করছে: /account/profile/)
      final url = ApiConstants.userProfile;
      print("🌐 Fetching profile from: $url");

      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print("📥 Profile Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        name.value = data['name'] ?? '';
        email.value = data['email'] ?? '';
        image.value = data['image'] ?? '';
        preferredLanguage.value = data['preferred_language'] ?? 'en';

        print("✅ Profile Loaded: ${data['name']}");
        print("✅ Language Preference: ${preferredLanguage.value}");
      } else {
        print("❌ Error: ${response.statusCode}");
        print("❌ Response: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Update profile with language preference support
  Future<bool> updateProfile({
    required String newName,
    String? newImage,
    String? languageCode,
  }) async {
    try {
      isLoading.value = true;
      String? token = await StorageHelper.getToken();

      if (token == null) {
        print("❌ No token found");
        return false;
      }

      // ✅ সঠিক URL - ApiConstants.userProfile
      final url = ApiConstants.userProfile;
      print("🌐 Updating profile at: $url");

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(url),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.fields['name'] = newName;

      // Send language to backend if provided
      if (languageCode != null && languageCode.isNotEmpty) {
        request.fields['preferred_language'] = languageCode;
        preferredLanguage.value = languageCode;
        print("📤 Sending language to backend: $languageCode");
      }

      // Include image if user selected one
      if (newImage != null && newImage.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('image', newImage));
        print("📤 Uploading image: $newImage");
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      print("📥 Update Response Status: ${response.statusCode}");
      print("📥 Update Response Body: ${responseData.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData.body);
        name.value = data['name'] ?? newName;
        email.value = data['email'] ?? '';
        image.value = data['image'] ?? '';
        preferredLanguage.value = data['preferred_language'] ?? languageCode ?? 'en';

        print("✅ Profile Updated Successfully");
        print("✅ Language updated to: ${preferredLanguage.value}");

        return true;
      } else {
        print("❌ Update Error: ${response.statusCode}");
        print("❌ Response: ${responseData.body}");
        return false;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Shorten long names
  String getTruncatedName(int maxLength) {
    if (name.value.length > maxLength) {
      return name.value.substring(0, maxLength) + '...';
    }
    return name.value;
  }

  // Full image URL
  String getFullImageUrl() {
    if (image.value.isEmpty) return '';
    if (image.value.startsWith('http')) return image.value;

    String cleanPath = image.value;
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }

    String cleanBaseUrl = baseUrl;
    if (cleanBaseUrl.endsWith('/')) {
      cleanBaseUrl = cleanBaseUrl.substring(0, cleanBaseUrl.length - 1);
    }

    return '$cleanBaseUrl/$cleanPath';
  }
}