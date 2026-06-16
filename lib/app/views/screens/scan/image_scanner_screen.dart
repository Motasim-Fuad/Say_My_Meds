// image_scanner_screen.dart - সম্পূর্ণ আপডেটেড

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:saymymeds/app/core/app_routes/app_routes.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:saymymeds/app/views/screens/view_details/view_controlr/view_detiails_controller.dart';
import 'package:saymymeds/app/widgets/BottomNav.dart';

class ImageScannerScreen extends StatefulWidget {
  const ImageScannerScreen({super.key});

  @override
  State<ImageScannerScreen> createState() => _ImageScannerScreenState();
}

class _ImageScannerScreenState extends State<ImageScannerScreen> {
  final ViewDetailsController controller = Get.put(ViewDetailsController());
  int _currentIndex = 1;

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
      appBar: AppBar(
        backgroundColor: AppColors.whiteBackground,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () => context.go(AppRoutes.homeViewPage),
            child: Image.asset('assets/icons/cross.png', width: 24, height: 24),
          ),
        ),
      ),
      backgroundColor: AppColors.whiteBackground,
      body: Obx(
            () => Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 150),

                  // Display selected image
                  controller.selectedImage.value != null
                      ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Builder(
                        builder: (_) {
                          final imgFile = controller.selectedImage.value;
                          if (imgFile == null) {
                            return const SizedBox.shrink();
                          }
                          if (!kIsWeb) {
                            return Image.file(
                              imgFile,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          }

                          final path = imgFile.path;
                          if (path.startsWith('http') ||
                              path.startsWith('https')) {
                            return Image.network(
                              path,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          }

                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text(
                                'Image preview not available on web',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                      : Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'No image selected',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // ✅ Capture / Gallery buttons with translations
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => controller.pickImageFromCamera(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.forgetPasswordOpacity,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'camera'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.pickImageFromGallery(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.photo,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'photos'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // ✅ Improved Loading Overlay with Message
            if (controller.isLoading.value || controller.hasLoadingMessage)
              Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Spinner
                        const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            color: Color(0xFF4F85AA),
                            strokeWidth: 4,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Loading Message
                        Obx(() => Text(
                          controller.getLoadingMessage.isNotEmpty
                              ? controller.getLoadingMessage
                              : 'Processing...'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                        )),

                        const SizedBox(height: 8),

                        // Subtitle / Hint
                        Obx(() => Text(
                          controller.getLoadingMessage.contains('Analyzing') ||
                              controller.getLoadingMessage.contains('Processing')
                              ? 'This may take a few seconds'.tr
                              : controller.getLoadingMessage.contains('Saving')
                              ? 'Please do not close the app'.tr
                              : '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        )),
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
}