import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:saymymeds/app/core/app_routes/app_routes.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:saymymeds/app/views/screens/medications/controler/check_info_controller/cheak_info_controller.dart';
import 'package:saymymeds/app/widgets/BottomNav.dart';

class CheckInfoPage extends StatefulWidget {
  final int medicationId;

  const CheckInfoPage({super.key, required this.medicationId});

  @override
  State<CheckInfoPage> createState() => _CheckInfoPageState();
}

class _CheckInfoPageState extends State<CheckInfoPage> {
  final CheckInfoController controller = Get.put(CheckInfoController());
  final TextEditingController noteController = TextEditingController();

  String selectedLang = 'English';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.fetchMedicationDetails(widget.medicationId);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

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
    const divider = Color(0xFF4F85AA);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.medicationDetails.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final details = controller.medicationDetails.value;
        if (details == null) {
          return const Center(child: Text('Failed to load medication details'));
        }

        return SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.10, -1.00),
                end: Alignment(0.10, 1.00),
                colors: [
                  Color(0xFF4F85AA),
                  Color(0xFFF8F9FB),
                  Color(0xFFF8F9FB),
                  Color(0xFFF8F9FB),
                  Color(0xFFF8F9FB),
                ],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Image.asset(
                                "assets/icons/Back_Icon.png",
                                width: 44,
                                height: 44,
                              ),
                              onPressed: () => context.pop(),
                            ),
                            const Spacer(),
                            Container(
                              width: 157,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: AppColors.whiteBackground,
                                  value: selectedLang,
                                  isExpanded: true,
                                  icon: const Icon(Icons.expand_more_rounded),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'English',
                                      child: Text('English'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Spanish',
                                      child: Text(
                                        'Spanish (Español)',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'French',
                                      child: Text(
                                        'French (Français)',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Creole',
                                      child: Text('Creole'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Russian',
                                      child: Text('Russian'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Chinese',
                                      child: Text('Chinese'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Portuguese',
                                      child: Text('Portuguese'),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) {
                                      setState(() => selectedLang = v);
                                      controller.changeLanguage(v);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Main card with loading overlay
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFC8D9E5),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Image area
                                      SizedBox(
                                        width: 360,
                                        height: 180,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: const Color(0xFFF8F9FB),
                                            ),
                                            child: Center(
                                              child: Obx(() {
                                                final imageUrl = controller
                                                    .processedImageUrl
                                                    .value;

                                                if (imageUrl.isEmpty) {
                                                  return const Icon(
                                                    Icons.medication_outlined,
                                                    size: 72,
                                                    color: Colors.grey,
                                                  );
                                                }

                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.network(
                                                    imageUrl,
                                                    width: 160,
                                                    height: 170,
                                                    fit: BoxFit.contain,
                                                    loadingBuilder:
                                                        (
                                                          _,
                                                          child,
                                                          loadingProgress,
                                                        ) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
                                                          return Container(
                                                            width: 145,
                                                            height: 170,
                                                            color: Colors
                                                                .grey[200],
                                                            child: const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          );
                                                        },
                                                    errorBuilder: (_, __, ___) {
                                                      print(
                                                        '❌ Image load failed: $imageUrl',
                                                      );
                                                      return const Icon(
                                                        Icons
                                                            .medication_outlined,
                                                        size: 72,
                                                        color: Colors.grey,
                                                      );
                                                    },
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // ✅ Play button with translation
                                      SizedBox(
                                        height: 100,
                                        width: 360,
                                        child: Obx(
                                          () => ElevatedButton.icon(
                                            onPressed: controller.toggleAudio,
                                            icon: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                controller.isPlaying.value
                                                    ? Icons.pause_rounded
                                                    : Icons.play_arrow_rounded,
                                                color: const Color(0xFF4F85AA),
                                                size: 50,
                                              ),
                                            ),
                                            label: Text(
                                              controller.getTranslation('play'),
                                              style: const TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF4F85AA,
                                              ),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // Title
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              details.genericName,
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      // Date + time
                                      Row(
                                        children: [
                                          _meta(
                                            '${details.createdAt.day.toString().padLeft(2, '0')}-${details.createdAt.month.toString().padLeft(2, '0')}-${details.createdAt.year}',
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            '|',
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          _meta(
                                            '${details.createdAt.hour.toString().padLeft(2, '0')}:${details.createdAt.minute.toString().padLeft(2, '0')}',
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      _divider(divider),

                                      // ✅ Info sections with translations
                                      _sectionTitle(controller, 'generic_name'),
                                      _sectionValue(details.genericName),
                                      _divider(divider),

                                      _sectionTitle(controller, 'brand_name'),
                                      _sectionValue(details.brandName),
                                      _divider(divider),

                                      _sectionTitle(controller, 'manufacturer'),
                                      _sectionValue(details.manufacturer),
                                      _divider(divider),

                                      _sectionTitle(controller, 'drug_class'),
                                      _sectionValue(details.drugClass),
                                      _divider(divider),

                                      _sectionTitle(controller, 'uses'),
                                      _sectionValue(details.uses),
                                      _divider(divider),

                                      _sectionTitle(
                                        controller,
                                        'dosage_information',
                                      ),
                                      const SizedBox(height: 6),
                                      _bulleter(
                                        '${controller.getTranslation("adults")}: ${details.dosageInformation.adultsDosage}',
                                      ),
                                      _bulleter(
                                        '${controller.getTranslation("children")}: ${details.dosageInformation.childrenDosage}',
                                      ),
                                      _bulleter(
                                        '${controller.getTranslation("elderly")}: ${details.dosageInformation.elderlyDosage}',
                                      ),
                                      _divider(divider),

                                      _sectionTitle(controller, 'how_to_take'),
                                      _sectionValue(details.howToTake),
                                      _divider(divider),

                                      _sectionTitle(controller, 'side_effects'),
                                      _bullet(
                                        '${controller.getTranslation("common")}: ${details.sideEffects.common}',
                                      ),
                                      _bullet(
                                        '${controller.getTranslation("serious")}: ${details.sideEffects.serious}',
                                      ),
                                      _divider(divider),

                                      _sectionTitle(controller, 'warnings'),
                                      _sectionValue(details.warnings),
                                      _divider(divider),

                                      _sectionTitle(
                                        controller,
                                        'storage_instructions',
                                      ),
                                      _sectionValue(
                                        details.storageInstructions,
                                      ),
                                      _divider(divider),

                                      _sectionTitle(controller, 'interactions'),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          details.interactions,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            height: 1.4,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),

                                      _divider(divider),

                                      // ✅ Add notes with translation
                                      _sectionTitle(controller, 'add_notes'),
                                      const SizedBox(height: 10),
                                      Container(
                                        height: 80,
                                        width: 360,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Obx(
                                                  () => TextField(
                                                    controller: noteController,
                                                    onChanged: (value) =>
                                                        controller
                                                                .noteText
                                                                .value =
                                                            value,
                                                    decoration: InputDecoration(
                                                      hintText: controller
                                                          .getTranslation(
                                                            'add_notes',
                                                          ),
                                                      hintStyle:
                                                          const TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  top: 3.0,
                                                ),
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 30,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Loading overlay - only shows during language change
                              if (controller.isLoading.value)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 0.5),

                    // ✅ Save button with translation
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: () {
                              controller.createNote();
                              noteController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0x804F85AA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              controller.getTranslation('save_note'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  // Helper widgets
  static Widget _meta(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 20,
      color: Colors.grey[600],
      fontWeight: FontWeight.w600,
    ),
  );

  // ✅ Updated with Obx for reactive translations
  static Widget _sectionTitle(CheckInfoController controller, String key) =>
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Obx(
          () => Text(
            controller.getTranslation(key),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
      );
  static Widget _sectionValue(String v) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Text(
      v,
      style: const TextStyle(fontSize: 20, height: 1.35, color: Colors.grey),
    ),
  );

  static Widget _bullet(String v) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 6, color: Colors.grey),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            v,
            style: const TextStyle(
              fontSize: 20,
              height: 1.4,
              color: Color(0xFF848484),
            ),
          ),
        ),
      ],
    ),
  );

  static Widget _bulleter(String v) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            v,
            style: const TextStyle(
              fontSize: 20,
              height: 1.4,
              color: Color(0xFF848484),
            ),
          ),
        ),
      ],
    ),
  );

  static Widget _divider(Color c) => const Padding(
    padding: EdgeInsets.only(top: 12),
    child: Divider(color: Color(0xFF4F85AA), thickness: 1),
  );
}
