import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:saymymeds/app/core/app_routes/app_routes.dart';
import 'dart:convert';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:saymymeds/app/views/components/AppSubtitleText/app_subtitle_text.dart';
import 'package:saymymeds/app/views/screens/auth/congratulations_popup.dart';
import 'package:saymymeds/app/views/components/AppHeadingText/app_hedaing_text.dart';
import 'package:saymymeds/app/views/components/CustomButton/custom_button.dart';
import 'package:saymymeds/app/views/components/CustomTextField/custom_text_field.dart';
import 'package:saymymeds/app/views/screens/auth/controller/new_password_controller.dart';

class NewPassword extends StatefulWidget {
  final String? resetToken;

  const NewPassword({super.key, this.resetToken});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final NewPasswordController controller = Get.put(NewPasswordController());

  String _resetToken = '';

  @override
  void initState() {
    super.initState();
    print('🚀 NewPassword initState');

    // Get token from widget parameter
    if (widget.resetToken != null && widget.resetToken!.isNotEmpty) {
      _resetToken = widget.resetToken!;
      print('✅ Token from widget: $_resetToken');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('🔄 NewPassword didChangeDependencies');

    // Only get from route if we don't have token yet
    if (_resetToken.isEmpty) {
      try {
        final routeState = GoRouterState.of(context);

        // Check extra parameter
        if (routeState.extra != null && routeState.extra is String) {
          final token = routeState.extra as String;
          if (token.isNotEmpty) {
            setState(() {
              _resetToken = token;
            });
            print('✅ Token from routeState.extra: $_resetToken');
            return;
          }
        }

        // Check query parameters
        final queryToken = routeState.uri.queryParameters['token'];
        if (queryToken != null && queryToken.isNotEmpty) {
          setState(() {
            _resetToken = queryToken;
          });
          print('✅ Token from query params: $_resetToken');
          return;
        }

        print('⚠️ No token found in route');
      } catch (e) {
        print('❌ Error getting token from route: $e');
      }
    }
  }

  void _handlePasswordReset() async {
    print('🔐 Password reset initiated');
    print('🎫 Current token: $_resetToken');

    controller.errorMessage.value = '';

    // Validate passwords
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      controller.errorMessage.value = 'Password fields cannot be empty';
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      controller.errorMessage.value = 'Passwords do not match';
      return;
    }

    // Check token
    if (_resetToken.isEmpty) {
      controller.errorMessage.value =
          'Reset token is missing. Please request a new password reset link.';
      print('❌ Token is empty');
      return;
    }

    print('✅ Proceeding with password reset');

    final success = await controller.setNewPassword(
      resetToken: _resetToken,
      newPassword: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    if (success && mounted) {
      print('✅ Password reset successful');
      CongratulationsPopup.show(context);

      // Navigate to signin
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          context.go(AppRoutes.siginIn);
        }
      });
    } else {
      print('❌ Password reset failed: ${controller.errorMessage.value}');
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        centerTitle: true,
        title: Image.asset("assets/images/Logo 4.png", height: 83, width: 88),
        leading: IconButton(
          icon: Image.asset(
            "assets/icons/Back_Icon.png",
            height: 44,
            width: 44,
          ),
          onPressed: () => context.go('/signin'),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Center(child: AppHeadingText("Set new password")),
                  const SizedBox(height: 15),
                  const Center(
                    child: Text(
                      "Please enter a new password and re-enter to confirm.",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                        color: Color(0xFF848484),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSubtitleText('New Password'),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: "*********",
                    controller: newPasswordController,
                    isPassword: true,
                    opatictyColor: '',
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSubtitleText('Confirm Password'),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: "*********",
                    controller: confirmPasswordController,
                    isPassword: true,
                    opatictyColor: '',
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Obx(
                () => Column(
                  children: [
                    if (controller.errorMessage.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.buttonColor,
                            ),
                          )
                        : CustomButton(
                            backgroundColor: AppColors.buttonColor,
                            text: "Continue",
                            onPressed: _handlePasswordReset,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
