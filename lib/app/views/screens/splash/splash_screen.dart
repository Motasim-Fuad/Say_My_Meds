import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay function to navigate to the next screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      context.go('/welcome'); // '/welcome' is your route path in go_router
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ensure the image path is correct
              Image.asset(
                "assets/images/.png.png",
                height: 572.h,
                width: 572.w,
                // fit: BoxFit.cover,
              ),

              SizedBox(height: 20.h),

              Text(
                "Say My Meds",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 40.sp,
                  height: 1.0,
                  letterSpacing: 0,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
