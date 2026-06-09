import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:saymymeds/app/views/components/AppHeadingText/app_hedaing_text.dart';
import 'package:saymymeds/app/views/components/CustomButton/custom_button.dart';
import 'package:saymymeds/app/views/screens/auth/controller/auth_controller.dart';

class VerifyCode extends StatefulWidget {
  final String email;
  const VerifyCode({super.key, required this.email});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final AuthController otpController = Get.put(AuthController());

  final TextEditingController otpTextController = TextEditingController();
  final otpCode = ''.obs;
  final isCodeFilled = false.obs;

  // ✅ Add countdown timer variables
  final canResend = false.obs;
  final resendCountdown = 60.obs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    print("Received email in VerifyCode: ${widget.email}");

    // ✅ Start countdown timer
    startResendTimer();
  }

  // ✅ Countdown timer function
  void startResendTimer() {
    canResend.value = false;
    resendCountdown.value = 30;

    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  // ✅ Resend OTP handler
  void handleResendOtp() {
    otpController.resendOtp(context, widget.email);
    startResendTimer(); // Restart countdown
  }

  @override
  void dispose() {
    _timer?.cancel();
    // otpTextController আগেই dispose হতে পারে, তাই try-catch
    try { otpTextController.dispose(); } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Center(child: AppHeadingText("Check your email")),
              const SizedBox(height: 30),

              Text(
                "Verification code sent to: ${widget.email}",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              /// OTP Pin Code Field
              FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: otpTextController,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: 60,
                      fieldWidth: 50,
                      inactiveFillColor: Colors.white,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      inactiveColor: Colors.grey.shade300,
                      activeColor: AppColors.primary,
                      selectedColor: AppColors.primary,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onChanged: (value) {
                      otpCode.value = value;
                      isCodeFilled.value = value.length == 6;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Verify Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    onPressed: isCodeFilled.value
                        ? () {
                            print(
                              "Sending OTP verification for email: ${widget.email}",
                            );
                            print("OTP code: ${otpTextController.text.trim()}");

                            otpController.verifyOtp(
                              context,
                              widget.email,
                              otpTextController.text.trim(),
                            );
                          }
                        : null,
                    backgroundColor: isCodeFilled.value
                        ? AppColors.primary
                        : const Color(0x804F85AA),
                    borderRadius: 15,
                    child: Text(
                      "Verify Code",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ✅ Updated Resend code section with countdown
              Column(
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

                  // ✅ Resend button with countdown
                  Obx(
                    () => GestureDetector(
                      onTap: canResend.value ? handleResendOtp : null,
                      child: Text(
                        canResend.value
                            ? "Resend code"
                            : "Resend in ${resendCountdown.value}s",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          height: 1.5,
                          color: canResend.value
                              ? const Color(0xFF4F85AA)
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
