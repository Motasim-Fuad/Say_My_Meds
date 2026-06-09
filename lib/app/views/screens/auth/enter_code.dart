import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:saymymeds/app/views/components/AppHeadingText/app_hedaing_text.dart';
import 'package:saymymeds/app/views/components/CustomButton/custom_button.dart';
import 'package:saymymeds/app/views/screens/auth/controller/enter_code_controller.dart';

// GetX Controller for EnterCode

class EnterCode extends StatelessWidget {
  const EnterCode({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.put(EnterCodeController());

    // Get email from GoRouter
    final state = GoRouterState.of(context);
    String email = 'mytrek@gmail.com';

    if (state.extra != null) {
      if (state.extra is String) {
        email = state.extra as String;
      } else if (state.extra is Map<String, dynamic>) {
        email = (state.extra as Map<String, dynamic>)['email'] ?? email;
      }
    }

    print('📧 EnterCode received email: $email');

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
              const SizedBox(height: 20),
              const Center(child: AppHeadingText("Check your email")),
              const SizedBox(height: 20),
              Text(
                "We sent a reset link to $email. Enter the 6-digit code mentioned in the email.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF848484),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              // Pin Code Field
              FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(16),
                      fieldHeight: 60,
                      fieldWidth: 50,
                      inactiveFillColor: Colors.white,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      inactiveColor: Colors.grey.shade300,
                      activeColor: Colors.blue,
                      selectedColor: Colors.blue,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onChanged: controller.updateOtp,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Error Message
              Obx(
                () => controller.errorMessage.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Verify Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    onPressed:
                        controller.isCodeFilled.value &&
                            !controller.isLoading.value
                        ? () => controller.verifyCode(email, context)
                        : null,
                    backgroundColor: controller.isCodeFilled.value
                        ? AppColors.primary
                        : const Color(0x804F85AA),
                    borderRadius: 15,
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Verify Code",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Resend code
              Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Haven't got the email yet?",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        height: 1.5,
                        color: Color(0xFF848484),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: controller.isLoading.value
                          ? null
                          : () => controller.resendCode(email, context),
                      child: Text(
                        "Resend code",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          height: 1.5,
                          color: controller.isLoading.value
                              ? const Color(0xFF848484)
                              : const Color(0xFF4F85AA),
                        ),
                      ),
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
