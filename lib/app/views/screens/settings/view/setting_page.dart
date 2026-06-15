import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:saymymeds/app/core/app_routes/app_routes.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:saymymeds/app/utlies/storage_helper.dart';
import 'package:saymymeds/app/widgets/BottomNav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:saymymeds/app/core/consants/api_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _currentIndex = 3;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        context.go(AppRoutes.homeViewPage);
        break;
      case 1:
        context.go(AppRoutes.imageScannerScreen);
        break;
      case 2:
        context.go(AppRoutes.medication);
        break;
      case 3:
        context.go(AppRoutes.settingPage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.50, 1.00),
                end: Alignment(0.50, -0.00),
                colors: [Color(0xFF4FAAA2), Color(0xFF4F85AA)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "Settings",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  height: 1.0,
                  letterSpacing: 0.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                buildSettingsTile(
                  Icons.person,
                  "Edit Profile",
                      () => context.push(AppRoutes.editProfile),
                ),
                buildSettingsTile(
                  Icons.language,
                  "Language Selection",
                      () => context.push(AppRoutes.languageSelection),
                ),
                buildSettingsTile(
                  Icons.privacy_tip_outlined,
                  "Privacy Policy",
                      () => _openUrl('${ApiConstants.baseUrl}/privacy-policy/'),
                ),
                buildSettingsTile(
                  Icons.description_outlined,
                  "Terms and Conditions",
                      () => _openUrl('${ApiConstants.baseUrl}/terms-and-conditions/'),
                ),
                buildSettingsTile(
                  Icons.info_outline,
                  "About Us",
                      () => _openUrl('${ApiConstants.baseUrl}/about-us/'),
                ),
                buildSettingsTile(
                  Icons.contact_mail_outlined,
                  "Contact Us",
                      () => _openUrl('${ApiConstants.baseUrl}/contact-us/'),
                ),
                const SizedBox(height: 20),
                buildDeleteAccountButton(),
                const SizedBox(height: 20),
                buildLogoutButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.forgetPasswordOpacity, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDeleteAccountButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showDeleteAccountDialog,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.delete_forever, color: Colors.red, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Delete Account",
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.red, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showLogoutDialog,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.logout, color: AppColors.primary, size: 24),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ সরাসরি ব্রাউজারে URL খোলার ফাংশন
  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Delete Account",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(fontSize: 16, color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteAccount();
              },
              child: const Text("Delete", style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF4F85AA)),
        ),
      );

      final token = await StorageHelper.getToken();
      if (token == null) {
        if (context.mounted) Navigator.pop(context);
        _showSnackbar('Error', 'No authentication token found');
        return;
      }

      // Log the URL for debugging
      print('Delete Account URL: ${ApiConstants.deleteAccount}');
      print('Token: $token');

      final response = await http.delete(
        Uri.parse(ApiConstants.deleteAccount),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json', // Add this to request JSON response
        },
      ).timeout(const Duration(seconds: 30));

      if (context.mounted) Navigator.pop(context);

      // Log the response for debugging
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        _showSnackbar('Success', 'Account deleted successfully');
        await StorageHelper.clearToken();
        if (context.mounted) {
          context.go(AppRoutes.siginIn);
        }
      } else {
        String errorMsg = 'Failed to delete account';

        // Check if response is HTML
        if (response.body.trim().startsWith('<!DOCTYPE') ||
            response.body.trim().startsWith('<html')) {
          errorMsg = 'Server error. Please check your API endpoint or try again later.';
          print('Server returned HTML instead of JSON. Status code: ${response.statusCode}');
        } else {
          try {
            final errorBody = json.decode(response.body);
            errorMsg = errorBody['error'] ?? errorBody['message'] ?? errorMsg;
          } catch (e) {
            print('Error parsing JSON: $e');
            errorMsg = 'Server error (Status: ${response.statusCode})';
          }
        }

        if (context.mounted) {
          _showSnackbar('Error', errorMsg);
        }
        print(errorMsg);
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      _showSnackbar('Error', 'Failed to delete account: $e');
      print('Exception: $e');
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                await StorageHelper.clearToken();
                if (context.mounted) {
                  context.go(AppRoutes.siginIn);
                }
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(String title, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title: $message'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: title == 'Error' ? Colors.redAccent : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}