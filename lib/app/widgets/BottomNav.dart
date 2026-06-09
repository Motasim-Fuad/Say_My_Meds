import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  void initState() {
    super.initState();
    // Ensure LanguageController is registered so GetBuilder has a controller to listen to
    if (!Get.isRegistered<LanguageController>()) {
      Get.put(LanguageController());
    }
  }

  double _indicatorLeft(BuildContext context) =>
      MediaQuery.of(context).size.width / 4 * widget.currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.whiteBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(6, 0),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Wrap only the row in GetBuilder so labels update when language changes
          GetBuilder<LanguageController>(
            builder: (controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    icon: Icons.home,
                    label: 'home'.tr,
                    index: 0,
                    isSelected: widget.currentIndex == 0,
                  ),
                  _buildNavItem(
                    icon: Icons.crop_free,
                    label: 'scan'.tr,
                    index: 1,
                    isSelected: widget.currentIndex == 1,
                  ),
                  _buildNavItem(
                    icon: Icons.medication,
                    label: 'medications'.tr,
                    index: 2,
                    isSelected: widget.currentIndex == 2,
                  ),
                  _buildNavItem(
                    icon: Icons.settings,
                    label: 'settings'.tr,
                    index: 3,
                    isSelected: widget.currentIndex == 3,
                  ),
                ],
              );
            },
          ),

          AnimatedPositioned(
            bottom: 0,
            left: _indicatorLeft(context),
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: 3,
              width: MediaQuery.of(context).size.width / 4,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    final iconColor = isSelected ? AppColors.buttonColor : AppColors.bgTextDark;
    final textColor = isSelected ? AppColors.buttonColor : AppColors.bgTextDark;

    return GestureDetector(
      onTap: () {
        widget.onTap(index);
        // Parent should update currentIndex and rebuild; no local setState needed
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// LanguageController used by GetBuilder for locale updates
class LanguageController extends GetxController {
  void updateLanguage(Locale locale) {
    Get.updateLocale(locale);
    update();
  }
}
