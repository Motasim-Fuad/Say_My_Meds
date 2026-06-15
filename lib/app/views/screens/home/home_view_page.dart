import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:saymymeds/app/core/app_routes/app_routes.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:saymymeds/app/views/screens/home/controller/home_page_&_edit_profilecontroller.dart';
import 'package:saymymeds/app/views/screens/home/controller/recently_scenned_controller.dart';
import 'package:saymymeds/app/views/screens/settings/view/setting_all_page_cntroller/global_languages_contrlooer.dart';
import 'package:saymymeds/app/widgets/BottomNav.dart';
import 'package:saymymeds/app/core/consants/api_constants.dart';

class HomeViewPage extends StatefulWidget {
  @override
  _HomeViewPageState createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeViewPage> {
  int _currentIndex = 0;
  final String baseUrl = ApiConstants.baseUrl;

  final HomePageEditProfilecontroller profileController = Get.put(
    HomePageEditProfilecontroller(),
  );
  final GlobalLanguageController globalLanguageController = Get.put(
    GlobalLanguageController(),
  );
  final RecentlyScannedController recentlyScannedController = Get.put(
    RecentlyScannedController(),
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

  // Pull to Refresh ফাংশন - fetchRecentlyScanned ব্যবহার করুন
  Future<void> _onRefresh() async {
    await recentlyScannedController.fetchRecentlyScanned(); // ✅ এখানে পরিবর্তন
    await profileController.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double scanMedicationFontSize = screenWidth < 360 ? 18 : 24;
    double scanInstructionFontSize = screenWidth < 360 ? 12 : 14;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ফিক্সড হেডার সেকশন
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            value: globalLanguageController.selectedDisplayLanguage.value,
                            isExpanded: true,
                            icon: const Icon(Icons.expand_more_rounded),
                            items: globalLanguageController.languageMap.keys.map((display) {
                              return DropdownMenuItem(
                                value: display,
                                child: Text(display),
                              );
                            }).toList(),
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
            const SizedBox(height: 10),

            // স্ক্রলেবল কন্টেন্ট (Pull to Refresh সহ)
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: const Color(0xFF4F85AA),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // স্ক্যান মেডিকেশন কার্ড
                      Container(
                        height: 500,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
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
                                      height: 280,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const Positioned(
                                    bottom: 20,
                                    left: 0,
                                    right: 0,
                                    child: Divider(thickness: 3.2, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'scan_medication'.tr,
                              style: TextStyle(
                                color: const Color(0xFFF8F9FB),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: scanMedicationFontSize,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => context.push("/imageScannerScreen"),
                              icon: const Icon(Icons.qr_code_scanner, size: 40),
                              label: Text(
                                'scan_button'.tr,
                                style: const TextStyle(
                                  color: Color(0xFF333333),
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 32,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: const Size(280, 70),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // রিসেন্টলি স্ক্যানড সেকশন
                      _buildRecentlyScannedSection(),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }


// রিসেন্টলি স্ক্যানড সেকশন বিল্ড করার মেথড
  Widget _buildRecentlyScannedSection() {
    return Obx(() {
      if (recentlyScannedController.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(50),
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFF4F85AA),
            ),
          ),
        );
      }

      if (recentlyScannedController.errorMessage.value.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(50),
          child: Center(
            child: Column(
              children: [
                Text(
                  recentlyScannedController.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => recentlyScannedController.fetchRecentlyScanned(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F85AA),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      final medicines = recentlyScannedController.medicines;

      if (medicines.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(50),
          child: Center(
            child: Text(
              'noMedicationsFound'.tr,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        );
      }

      // ✅ এখন medicines ইতিমধ্যেই sorted (বড় ID প্রথমে)
      // শুধু প্রথম ২টা দেখাবে (সর্বশেষ ২টা)
      final latestTwoMedicines = medicines.length >= 2
          ? medicines.sublist(0, 2)  // ID 7, 6 এই ক্রমে
          : medicines;

      print('🏠 Home: Showing ${latestTwoMedicines.length} items');
      for (var med in latestTwoMedicines) {
        print('   🏠 Displaying ID: ${med.id}, Name: ${med.genericName}');
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'recently_scanned'.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.push("/medication");
                  },
                  child: Text(
                    'see_all'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4F85AA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                ...latestTwoMedicines.map((medicine) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMedicineCard(medicine),
                )),
              ],
            ),
          ),
        ],
      );
    });
  }

  // মেডিসিন কার্ড বিল্ড করার মেথড
  Widget _buildMedicineCard(dynamic medicine) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: Color(0xFF4F85AA),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '$baseUrl${medicine.originalImage}',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.medication_outlined,
                    size: 40,
                    color: Colors.grey,
                  ),
                  loadingBuilder: (_, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Medicine Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.genericName,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        TextSpan(
                          text: "${'genericName'.tr}: ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: medicine.brandName ?? '',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(medicine.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.push("/checkInfoPage/${medicine.id}");
                        },
                        child: Text(
                          'viewDetails'.tr,
                          style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: Color(0xFF4F85AA),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ডেট ফরম্যাট করার মেথড
  String _formatDate(dynamic date) {
    if (date == null) return '';
    DateTime parsedDate;
    if (date is String) {
      parsedDate = DateTime.tryParse(date) ?? DateTime.now();
    } else if (date is DateTime) {
      parsedDate = date;
    } else {
      return '';
    }
    return '${parsedDate.day.toString().padLeft(2, '0')}/'
        '${parsedDate.month.toString().padLeft(2, '0')}/'
        '${parsedDate.year}';
  }
}