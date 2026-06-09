import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saymymeds/app/core/app_routes/app_routes.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:saymymeds/app/views/components/CustomButton/custom_button.dart';
import 'package:saymymeds/app/widgets/BottomNav.dart';

class SubscriptionCard extends StatefulWidget {
  const SubscriptionCard({super.key});

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  int _currentIndex = 0;

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
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            boxShadow: [
              BoxShadow(
                color: const Color(0x26000000),
                offset: const Offset(0, 2),
                blurRadius: 10,
              ),
            ],
          ),
          child: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                "assets/icons/cross.png",
                width: 44,
                height: 44,
              ),
            ),
            title: const Center(
              child: Text(
                "Subscription Plan",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: AppColors.primary,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Image.asset(
              "assets/images/Logo 4.png",
              width: 88,
              height: 83,
            ),
          ),
          const SizedBox(height: 25),

          // Subscription Cards
          bannerWidgetNextSupportSayMyMeds(
            textParts: [
              "Helping People Safely Read Their Prescriptions Say My Meds provides voice support for people with vision loss, limited literacy, or trouble identifying their medications. Your support makes it possible.",
            ],
          ),
          SizedBox(height: 25),
          subscriptionCard(
            title: "Member — Free ",
            price: "\$0",
            features: [
              "Read up to 3 prescriptions daily (3 scans)",
              " Free with ads",
              // "Monthly updates & user stories ",
            ],
            buttonText: "Current Plan",
            buttonColor: AppColors.lightBlueGray,
          ),

          const SizedBox(height: 25),
          subscriptionCard(
            title: "Voice Booster",
            price: "\$4.99",
            features: [
              "Read up to 10 prescriptions daily (10 scans) ",
              "Monthly updates & user stories",
              // "Behind-the-scenes updates ",
            ],
            buttonText: "Purchase Plan",
            buttonColor: AppColors.buttonColor,
          ),

          const SizedBox(height: 25),
          bannerWidget(
            textParts: [
              "Your donation helps bring ",
              "voice-based prescription support",
              "  Every tier helps us grow, reach more users, and build a safer, ",
            ],
          ),

          const SizedBox(height: 25),
          subscriptionCard(
            title: "Accessibility Advocate",
            price: "\$12.99",
            features: [
              "Read up to 30 prescriptions daily (30 scans)",
              "Monthly updates & user stories",
              "Digital badge + printable certificate",
              "Your name listed on our supporter credits web page",
            ],
            buttonText: "Purchase Plan",
            buttonColor: AppColors.buttonColor,
          ),
          const SizedBox(height: 25),

          bannerWidgetNext(
            textParts: [
              "50 million Americans live with some degree of vision impairment (American Foundation for the Blind).",
              "43 million U.S. adults are illiterate or functionally illiterate (National Literacy Institute).",
              "54% of U.S. adults read below a 6th-grade level (APM Research Lab).",
              "Your contribution helps people stay safe, independent, and avoid medical emergencies caused by medication mix-ups.",
            ],
          ),
          const SizedBox(height: 25),
          subscriptionCard(
            title: "Health Hero",
            price: "\$200",
            features: [
              "Unlimited daily prescription reads ",
              "Donate an “Accessibility Advocate” subscription to a low-vision user",
              "“Supporter Spotlight” mention in our newsletter or social media ",
              "Digital badge + printable certificate",
              "Input on new features through exclusive surveys",
              "Name/logo listed as a gold sponsor on our website ",
            ],
            buttonText: "Purchase Plan",
            buttonColor: AppColors.buttonColor,
          ),

          const SizedBox(height: 25),
          subscriptionCard(
            title: "Visionary Sponsor",
            price: "\$500",
            features: [
              "Unlimited prescription reads and an  “Accessibility Advocate” membership to donate",
              "Annual gift box",
              "Name/logo listed as a platinum sponsor on our website and in the app",
              "Quarterly call with leadership to share milestone progress",
              "Monthly updates & user stories",
              "Digital badge + printable certificate One-Time Donations",
              "Want to help without a monthly plan? Visit saymymeds.com or contact us directly.",
            ],
            buttonText: "Purchase Plan",
            buttonColor: AppColors.buttonColor,
          ),

          const SizedBox(height: 25),
          bannerWidget(
            textParts: [
              "Want to help without a monthly plan? Visit ",
              "saymymeds.com/donate",
              " or contact us directly.",
            ],
            isDonation: true,
          ),

          const SizedBox(height: 25),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget subscriptionCard({
    required String title,
    required String price,
    required List<String> features,
    required String buttonText,
    required Color buttonColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.bgTextDark,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const TextSpan(
                  text: " /month",
                  style: TextStyle(fontSize: 20, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          ...features.map((e) => buildFeature(e)).toList(),
          const SizedBox(height: 25),
          CustomButton(
            backgroundColor: buttonColor,
            child: Text(
              buttonText,
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: const Color(0xFFF8F9FB),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bannerWidget({
    List<String>? textParts,
    bool isDonation = false,
    Widget? customContent,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('assets/icons/Slogun banner.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            customContent ??
            (isDonation
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 327,
                        height: 63,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "One-Time Donations",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: textParts![0],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: textParts[1],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: textParts[2],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: textParts![0],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: textParts[1],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: textParts[2],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )),
      ),
    );
  }

  /*
  Widget bannerWidgetNext({List<String>? textParts, Widget? customContent}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('assets/icons/Slogun banner.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            customContent ??
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Why Your Support Matters ",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: AppColors.stroke2,
                    ),
                  ),
                ),
                ...textParts!.map(
                  (line) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "•  ", // Bullet symbol
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            // textAlign: TextAlign.jus
                            line,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
*/
  Widget bannerWidgetNext({List<String>? textParts, Widget? customContent}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('assets/icons/Slogun banner.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            customContent ??
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 327,
                  height: 63,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      " Why Your Support Matters",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ...textParts!.asMap().entries.map((entry) {
                  int index = entry.key;
                  String line = entry.value;
                  bool isLast = index == textParts.length - 1;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isLast)
                          const Text(
                            "•  ", // Only show bullet if not last line
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            line,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              height: 1.4,
                            ),
                            // textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
      ),
    );
  }
  /*


  */

  Widget bannerWidgetNextSupportSayMyMeds({
    List<String>? textParts,
    Widget? customContent,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('assets/icons/Slogun banner.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            customContent ??
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 327,
                  height: 63,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Support Say My Meds",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ...textParts!.asMap().entries.map((entry) {
                  int index = entry.key;
                  String line = entry.value;
                  bool isLast = index == textParts.length - 1;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isLast)
                          const Text(
                            "•  ", // Only show bullet if not last line
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            line,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              height: 1.4,
                            ),
                            // textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
      ),
    );
  }
  //////////////////////////////////////////////////////////////////////////////

  Widget buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Image(
            image: AssetImage('assets/icons/check.png'),
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
