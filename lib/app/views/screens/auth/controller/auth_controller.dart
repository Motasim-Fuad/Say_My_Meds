import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:saymymeds/app/core/app_routes/app_routes.dart';
import 'package:saymymeds/app/core/consants/api_constants.dart';
import 'package:saymymeds/app/utlies/storage_helper.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  RxBool isCodeFilled = false.obs;

  // ─────────────────────────────────────────────
  // LOGIN
  // ─────────────────────────────────────────────
  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required bool rememberMe,  // Add this parameter
  }) async {
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, "Both Email and Password are required");
      return;
    }

    isLoading.value = true;

    try {
      print("📤 Sending login request for: $email");

      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {"email": email, "password": password},
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        throw TimeoutException('Connection timeout');
      });

      print("📥 Login Response Status: ${response.statusCode}");
      print("📥 Login Response Body: ${response.body}");

      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String? accessToken;

        if (data["token"] != null) {
          if (data["token"] is Map) {
            accessToken = data["token"]["access"]?.toString();
          } else if (data["token"] is String) {
            accessToken = data["token"];
          }
        } else if (data["access"] != null) {
          accessToken = data["access"].toString();
        } else if (data["access_token"] != null) {
          accessToken = data["access_token"].toString();
        }

        print("🔑 Extracted Token: ${accessToken != null ? 'Found (${accessToken.length} chars)' : 'NOT FOUND'}");

        if (accessToken != null && accessToken.isNotEmpty) {
          // Save token
          await StorageHelper.saveToken(accessToken);
          // Save remember me preference
          await StorageHelper.saveRememberMe(rememberMe);

          print("✅ Remember me preference saved: $rememberMe");
        } else {
          print("❌ No token found in response!");
        }

        if (!context.mounted) return;
        _showSnackBar(context, "Login Successful ✅", isSuccess: true);
        context.go(AppRoutes.homeViewPage);
      } else {
        if (!context.mounted) return;
        final message = _extractErrorMessage(data) ?? "Invalid credentials ❌";
        _showSnackBar(context, message);
      }
    } on SocketException {
      if (!context.mounted) return;
      _showSnackBar(context, "No internet connection ❌");
    } on TimeoutException {
      if (!context.mounted) return;
      _showSnackBar(context, "Connection timeout. Please try again ⏱️");
    } on FormatException {
      if (!context.mounted) return;
      _showSnackBar(context, "Invalid server response");
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, "Error: ${e.toString()}");
      print("❌ Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // REGISTER
  // ─────────────────────────────────────────────
  Future<void> register({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String password2,
  }) async {
    isLoading.value = true;

    try {
      print("📤 Sending registration request for: $email");

      final response = await http.post(
        Uri.parse(ApiConstants.signup),
        headers: {"Accept": "application/json"},
        body: {
          "name": name,
          "email": email,
          "password": password,
          "password2": password2,
        },
      );

      print("📥 Register Response Status: ${response.statusCode}");
      print("📥 Register Response Body: ${response.body}");

      late Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        if (!context.mounted) return;
        _showSnackBar(context, "Invalid server response");
        return;
      }

      if (!context.mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _showSnackBar(context, "Registration successful ✅", isSuccess: true);
        context.push(AppRoutes.verifyCode, extra: {"email": email});
      } else {
        final message = _extractErrorMessage(data) ?? "Registration failed";
        _showSnackBar(context, message);
      }
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, "Error: $e");
      print("❌ Register error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // VERIFY OTP
  // ─────────────────────────────────────────────
  Future<void> verifyOtp(BuildContext context, String email, String otp) async {
    if (email.isEmpty) {
      _showSnackBar(context, "Email is required");
      return;
    }
    if (otp.isEmpty || otp.length != 6) {
      _showSnackBar(context, "Please enter a valid 6-digit OTP");
      return;
    }

    isLoading.value = true;

    try {
      print("📤 Verifying OTP for: $email");
      print("📤 OTP: $otp");

      final response = await http.post(
        Uri.parse(ApiConstants.otpVerify),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {"email": email.trim(), "otp": otp.trim()},
      );

      print("📥 OTP Response Status: ${response.statusCode}");
      print("📥 OTP Response Body: ${response.body}");

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        String? accessToken;

        if (data["token"] != null) {
          if (data["token"] is Map) {
            accessToken = data["token"]["access"]?.toString();
          } else if (data["token"] is String) {
            accessToken = data["token"];
          }
        } else if (data["access"] != null) {
          accessToken = data["access"].toString();
        }

        print("🔑 Extracted Token from OTP: ${accessToken != null ? 'Found' : 'NOT FOUND'}");

        if (accessToken != null && accessToken.isNotEmpty) {
          await StorageHelper.saveToken(accessToken);

          // ✅ Verify token was saved
          String? savedToken = await StorageHelper.getToken();
          print("✅ Token saved from OTP: ${savedToken != null ? 'YES' : 'NO'}");
        }

        if (!context.mounted) return;
        _showSnackBar(
          context,
          data["msg"] ?? data["message"] ?? "OTP Verified Successfully ✅",
          isSuccess: true,
        );
        context.go(AppRoutes.siginIn);
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        final message = _extractErrorMessage(errorData) ??
            "Verification failed. Please try again.";

        _showSnackBar(context, message);

        if (message.toLowerCase().contains("already activated")) {
          context.go(AppRoutes.siginIn);
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, "Something went wrong: ${e.toString()}");
      print("❌ OTP error: $e");
    } finally {
      isLoading.value = false;
    }
  }



  // ─────────────────────────────────────────────
  // RESEND OTP
  // ─────────────────────────────────────────────
  Future<void> resendOtp(BuildContext context, String email) async {
    OverlayEntry? overlayEntry;

    try {
      overlayEntry = OverlayEntry(
        builder: (_) => Container(
          color: Colors.black54,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(overlayEntry);

      print("📤 Resending OTP for: $email");

      final response = await http.post(
        Uri.parse(ApiConstants.resendOtp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      overlayEntry.remove();
      overlayEntry = null;

      print("📥 Resend OTP Response: ${response.statusCode}");

      if (!context.mounted) return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar(
          context,
          data['msg'] ?? data['message'] ?? 'OTP has been resent to your email',
          isSuccess: true,
        );
      } else {
        final message = _extractErrorMessage(data) ?? 'Failed to resend OTP';
        _showSnackBar(context, message);
      }
    } catch (e) {
      overlayEntry?.remove();
      if (!context.mounted) return;
      _showSnackBar(context, 'Network error: Please check your connection');
      print("❌ Resend OTP error: $e");
    }
  }

  // ─────────────────────────────────────────────
  // CHECK AUTH STATUS
  // ─────────────────────────────────────────────
  Future<bool> isLoggedIn() async {
    String? token = await StorageHelper.getToken();
    bool hasToken = token != null && token.isNotEmpty;
    print("🔐 Auth Check: ${hasToken ? 'Logged In' : 'Not Logged In'}");
    return hasToken;
  }

  // ─────────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────────
  Future<void> logout(BuildContext context) async {
    await StorageHelper.clearAllData();  // Clear all data
    print("🚪 User logged out - all data cleared");
    if (context.mounted) {
      context.go(AppRoutes.siginIn);
    }
  }

  Future<bool> shouldAutoLogin() async {
    bool rememberMe = await StorageHelper.getRememberMe();
    if (!rememberMe) {
      // If remember me is false, clear token and return false
      await StorageHelper.clearToken();
      return false;
    }

    String? token = await StorageHelper.getToken();
    return token != null && token.isNotEmpty;
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────
  String? _extractErrorMessage(Map<String, dynamic> data) {
    // Direct message keys
    for (final key in ['message', 'msg', 'detail', 'error']) {
      if (data[key] is String && (data[key] as String).isNotEmpty) {
        return data[key] as String;
      }
    }

    // non_field_errors list
    final nfe = data['non_field_errors'];
    if (nfe is List && nfe.isNotEmpty) return nfe.first.toString();

    // errors sub-object
    final errors = data['errors'];
    if (errors is Map) {
      for (final key in ['non_field_errors', 'email', 'password', 'detail']) {
        final v = errors[key];
        if (v is List && v.isNotEmpty) return v.first.toString();
        if (v is String && v.isNotEmpty) return v;
      }
    }

    return null;
  }

  void _showSnackBar(
      BuildContext context,
      String message, {
        bool isSuccess = false,
      }) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}