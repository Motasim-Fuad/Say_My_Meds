import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:saymymeds/app/core/app_routes/app_routes.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:saymymeds/app/views/screens/home/controller/home_page_&_edit_profilecontroller.dart';
import 'package:saymymeds/app/views/screens/home/views/screens/recently_scznned.dart';
import 'package:saymymeds/app/views/screens/settings/view/setting_all_page_cntroller/global_languages_contrlooer.dart';
import 'package:saymymeds/app/widgets/BottomNav.dart';

class HomeViewPage extends StatefulWidget {
  @override
  _HomeViewPageState createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeViewPage> {
  int _currentIndex = 0;

  final HomePageEditProfilecontroller profileController = Get.put(
    HomePageEditProfilecontroller(),
  );
  final GlobalLanguageController globalLanguageController = // ✅ Changed name
  Get.put(
    GlobalLanguageController(),
  );

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
    double screenWidth = MediaQuery.of(context).size.width;
    double scanMedicationFontSize = screenWidth < 360 ? 18 : 24;
    double scanInstructionFontSize = screenWidth < 360 ? 12 : 14;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 25),

              // ================= HEADER SECTION =================
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left: Profile & Name
                    Expanded(
                      child: Row(
                        children: [
                          Obx(() {
                            return CircleAvatar(
                              radius: 24,
                              backgroundImage: profileController.image.value.isNotEmpty
                                  ? NetworkImage(profileController.getFullImageUrl())
                                  : const AssetImage("assets/images/default_avatar.png") as ImageProvider,
                              onBackgroundImageError: (_, __) {
                                print('Failed to load profile image');
                              },
                              child: profileController.image.value.isEmpty
                                  ? Text(
                                profileController.name.value.isNotEmpty
                                    ? profileController.name.value[0].toUpperCase()
                                    : 'U',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              )
                                  : null,
                            );
                          }),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Obx(() {
                              return Text(
                                "${'hello'.tr}, ${profileController.getTruncatedName(15)}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // ✅ Center: Language Dropdown
                    Expanded(
                      child: Obx(() {
                        return Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.buttonColor),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              value: globalLanguageController
                                  .selectedDisplayLanguage
                                  .value,
                              isExpanded: true,
                              icon: const Icon(Icons.expand_more_rounded),
                              items: globalLanguageController.languageMap.keys
                                  .map((display) {
                                    return DropdownMenuItem(
                                      value: display,
                                      child: Text(display),
                                    );
                                  })
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  globalLanguageController.changeLanguage(v);
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(width: 8),

                    // Right: Subscription Icon
                    InkWell(
                      onTap: () {
                        context.push("/subscriptionCard");
                      },
                      child: Image.asset(
                        "assets/icons/raja.png",
                        width: 44,
                        height: 44,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= SCAN MEDICATION CARD =================
              Container(
                height: 573,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4FAAA2), Color(0xFF4F85AA)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color.fromRGBO(248, 249, 251, 0),
                            const Color.fromRGBO(79, 133, 170, 0.9),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: 323,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Positioned(
                            bottom: 30,
                            left: 0,
                            right: 0,
                            child: Divider(thickness: 3.2, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'scan_medication'.tr,
                      style: TextStyle(
                        color: const Color(0xFFF8F9FB),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: scanMedicationFontSize,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'scan_instruction'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFF8F9FB),
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: scanInstructionFontSize,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => context.push("/imageScannerScreen"),
                      icon: const Icon(Icons.qr_code_scanner, size: 50),
                      label: Text(
                        'scan_button'.tr,
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 40,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(320, 84),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ================= RECENTLY SCANNED SECTION =================
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'recently_scanned'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 700, child: const RecentlyScznned()),
                ],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
