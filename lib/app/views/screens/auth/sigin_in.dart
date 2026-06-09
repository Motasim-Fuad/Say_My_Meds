import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:saymymeds/app/views/components/AppHeadingText/app_hedaing_text.dart';
import 'package:saymymeds/app/views/components/AppSubtitleText/app_subtitle_text.dart';
import 'package:saymymeds/app/views/components/CustomButton/custom_button.dart';
import 'package:saymymeds/app/views/components/CustomTextField/custom_text_field.dart';
import 'package:http/http.dart';
import 'package:saymymeds/app/views/screens/auth/controller/auth_controller.dart';

class SiginInViews extends StatefulWidget {
  const SiginInViews({super.key});

  @override
  State<SiginInViews> createState() => _SiginInViewsState();
}

class _SiginInViewsState extends State<SiginInViews> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  bool rememberMe = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 88,
                      height: 80,
                      decoration: BoxDecoration(
                        // color: const Color(0xFF5B9BD5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Image.asset("assets/images/Logo 4.png"),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 250,
                      height: 60,
                      decoration: BoxDecoration(
                        // color: const Color(0xFF5B9BD5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(child: AppHeadingText("Sign in")),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSubtitleText('Email'),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {},
                    child: CustomTextField(
                      // label: "Email",
                      //  icon: Icons.email, // You need to specify an icon here
                      hintText: "emilysm@gmail.com",
                      controller: emailController,
                      opatictyColor: '', // Optional, only if needed
                    ),
                  ),
                  const SizedBox(height: 15),
                  const AppSubtitleText('Password'),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: "*********",
                    controller: passwordController,
                    isPassword: true,
                    opatictyColor: '', // This enables suffixIcon toggle
                  ),
                ],
              ),

              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF5B9BD5),
                        // materialTapTargetSize: materialTapTargetSize.shri,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),

                      const Text(
                        'Remember me',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          color: Color(0xFF848484),
                          fontWeight: FontWeight.w600, // SemiBold
                          fontStyle: FontStyle
                              .normal, // SemiBold has no specific font-style in Flutter
                          fontSize: 18.0,
                          height:
                              1.0, // 100% line-height (this is the same as line-height: 100%)
                          letterSpacing: 0.0, // 0% letter-spacing
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  TextButton(
                    onPressed: () {
                      // Forgot password action
                      // context.go()
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: InkWell(
                      onTap: () => {context.go("/forgetPasswordScreen")},
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400, // Regular
                          fontStyle: FontStyle.normal, // Regular
                          fontSize: 18.0,
                          height: 1.0, // 100% line-height
                          letterSpacing: 0.0, // 0px letter-spacing
                          color: Color(0xFF4F85AA),
                          decoration:
                              TextDecoration.underline, // Underline decoration
                          decorationStyle:
                              TextDecorationStyle.solid, // Solid underline
                          decorationThickness: 1.0, // Default thickness
                          // Skip ink (use if needed)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),

              // here of this screen login
              // CustomButton(
              //   backgroundColor: AppColors.buttonColor,
              //   child: Text(
              //     "Login",
              //     style: GoogleFonts.poppins(
              //       color: Colors.white,
              //       fontSize: 16,
              //       fontWeight: FontWeight.w600,
              //       height: 1.0,
              //     ),
              //   ),
              //   onPressed: () {},
              // ),
              Obx(
                () => CustomButton(
                  backgroundColor: AppColors.buttonColor,
                  onPressed: authController.isLoading.value
                      ? null
                      : () {
                          authController.login(
                            context: context,
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                        },
                  child: authController.isLoading.value
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have any account? ',
                    style: GoogleFonts.openSans(
                      color: Color(0xFF333333), // Correct color
                      fontSize: 17, // 24px
                      fontWeight: FontWeight.w600, // SemiBold
                      fontStyle: FontStyle.normal, // normal style
                      height: 1.0, // line-height: 100%
                      letterSpacing: 0.0, // letter-spacing: 0
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Sign up action
                      context.go("/signUp");
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700, // Bold
                        fontStyle:
                            FontStyle.normal, // Bold is handled by FontWeight
                        fontSize: 18.0,
                        height: 1.0, // line-height: 100%
                        letterSpacing: 0.0, // 0px letter-spacing
                        color: Color(0xFF4F85AA),
                        // Default color, change if needed
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
