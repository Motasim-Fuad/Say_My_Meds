import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saymymeds/app/core/app_routes/app_routes.dart';
import 'package:saymymeds/app/core/consants/api_constants.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:saymymeds/app/views/components/AppHeadingText/app_hedaing_text.dart';
import 'package:saymymeds/app/views/components/AppSubtitleText/app_subtitle_text.dart';
import 'package:saymymeds/app/views/components/CustomButton/custom_button.dart';
import 'package:saymymeds/app/views/components/CustomTextField/custom_text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isEmailFilled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() => isEmailFilled = emailController.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetPasswordEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains("@")) {
      _showSnackBar("Please enter a valid email address");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        // ✅ Use ApiConstants instead of hardcoded IP
        Uri.parse('${ApiConstants.baseUrl}/account/send-reset-password-email/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (!mounted) return;
      setState(() => isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar(
          "Password reset code sent to your email",
          isSuccess: true,
        );
        context.go(AppRoutes.enterCode, extra: email);
      } else {
        try {
          final errorData = json.decode(response.body) as Map<String, dynamic>;
          final message = _extractErrorMessage(errorData) ??
              "Failed to send reset email";
          _showSnackBar(message);
        } catch (_) {
          _showSnackBar("Failed to send reset email");
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showSnackBar("Network error. Please try again.");
    }
  }

  String? _extractErrorMessage(Map<String, dynamic> data) {
    for (final key in ['message', 'msg', 'detail', 'error']) {
      if (data[key] is String && (data[key] as String).isNotEmpty) {
        return data[key] as String;
      }
    }
    final nfe = data['non_field_errors'];
    if (nfe is List && nfe.isNotEmpty) return nfe.first.toString();
    return null;
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        centerTitle: true,
        elevation: 0,
        title: Image.asset("assets/images/Logo 4.png", height: 83, width: 88),
        leading: IconButton(
          icon: Image.asset(
            "assets/icons/Back_Icon.png",
            height: 44,
            width: 44,
          ),
          onPressed: () => context.go('/signin'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
                child: Center(child: AppHeadingText("Forgot Password")),
              ),
              const SizedBox(height: 8),
              const Text(
                "Provide the email linked to your account. We'll send a password reset link to your inbox.",
                style: TextStyle(
                  color: Color(0xFF848484),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  height: 1.5,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSubtitleText('Email'),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: "emilysm@gmail.com",
                    controller: emailController,
                    opatictyColor: '',
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  onPressed: isEmailFilled && !isLoading
                      ? _sendResetPasswordEmail
                      : null,
                  backgroundColor: isEmailFilled
                      ? AppColors.primary
                      : const Color(0x804F85AA),
                  borderRadius: 15,
                  child: isLoading
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : Text(
                    "Verify Code",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: const Color(0xFFF8F9FB),
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}