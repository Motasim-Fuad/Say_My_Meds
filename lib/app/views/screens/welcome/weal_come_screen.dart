import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saymymeds/app/views/components/AppTitleText/app_title_text.dart';
import 'package:saymymeds/app/views/components/CustomButton/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 🖼️ Top Image
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 506,
                      width: 500,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: -109,
                            child: Image.asset(
                              "assets/images/Hand_jar.png",
                              width: 633,
                              height: 509,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 📄 Text Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Headline
                          AppTitleText("Identify Your Medication Instantly"),
                          const SizedBox(height: 15),

                          // Description
                          Text(
                            "Scan any pill bottle or package with AI and get accurate details, dosage, and safety information right on your device.",
                            style: GoogleFonts.openSans(
                              color: const Color(0xFF848484),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              height: 1.0,
                            ),textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Button at Bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0,left: 16,right: 16),
              child: CustomButton(
                backgroundColor: AppColors.buttonColor,
                child: Text(
                  "Get start",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
                onPressed: () {
                  context.go('/signin');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}