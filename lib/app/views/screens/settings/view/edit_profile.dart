// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:go_router/go_router.dart';
// import 'package:saymymeds/app/core/app_routes/app_routes.dart';
// import 'package:saymymeds/app/utlies/apps_color.dart';
// import 'package:saymymeds/app/widgets/BottomNav.dart';
// import 'package:saymymeds/app/views/screens/home/controller/home_page_edit_profilecontroller.dart';

// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
//   int _currentIndex = 3;
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   late TextEditingController _nameController;
//   final ProfileController profileController = Get.find<ProfileController>();

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: profileController.name.value);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 80,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   void _onNavTap(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//     switch (index) {
//       case 0:
//         context.go(AppRoutes.homeViewPage);
//         break;
//       case 1:
//         context.go(AppRoutes.imageScannerScreen);
//         break;
//       case 2:
//         context.go(AppRoutes.medication);
//         break;
//       case 3:
//         context.go(AppRoutes.settingPage);
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FB),
//       resizeToAvoidBottomInset: true,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60.0),
//         child: Container(
//           decoration: const BoxDecoration(
//             color: Color(0xFFF8F9FB),
//             boxShadow: [
//               BoxShadow(
//                 color: Color(0x26000000),
//                 offset: Offset(0, 2),
//                 blurRadius: 10,
//               ),
//             ],
//           ),
//           child: AppBar(
//             leading: InkWell(
//               onTap: () {
//                 context.pop("/");
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset(
//                   "assets/icons/Back_Icon.png",
//                   width: 24,
//                   height: 24,
//                 ),
//               ),
//             ),
//             title: const Text(
//               "Edit Profile",
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w600,
//                 fontSize: 24,
//                 height: 1,
//                 color: AppColors.primary,
//               ),
//             ),
//             centerTitle: true,
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // Profile Image
//               Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   Obx(() {
//                     return CircleAvatar(
//                       radius: 50,
//                       backgroundImage: _image != null
//                           ? FileImage(_image!)
//                           : (profileController.image.value.isNotEmpty
//                                     ? NetworkImage(
//                                         profileController.getFullImageUrl(),
//                                       )
//                                     : const AssetImage(
//                                         'assets/images/eclipe.png',
//                                       ))
//                                 as ImageProvider,
//                     );
//                   }),
//                   GestureDetector(
//                     onTap: _pickImage,
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: AppColors.forgetPasswordOpacity,
//                       ),
//                       child: const Icon(
//                         Icons.camera_alt,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: const Text(
//                   "Change photo",
//                   style: TextStyle(color: AppColors.forgetPasswordOpacity),
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // Name field
//               TextField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: "Full name",
//                   labelStyle: TextStyle(color: AppColors.grey, fontSize: 18),
//                   border: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 50),

//               // Save button
//               Obx(() {
//                 return SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.buttonColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onPressed: profileController.isLoading.value
//                         ? null
//                         : () async {
//                             String newName = _nameController.text.trim();
//                             if (newName.isEmpty) {
//                               Get.snackbar("Error", "Name cannot be empty");
//                               return;
//                             }

//                             bool success = await profileController
//                                 .updateProfile(
//                                   newName: newName,
//                                   newImage: _image?.path,
//                                 );

//                             if (success) {
//                               Get.snackbar(
//                                 "Success",
//                                 "Profile updated successfully ✅",
//                               );
//                               Future.delayed(
//                                 const Duration(milliseconds: 500),
//                                 () {
//                                   context.go(AppRoutes.homeViewPage);
//                                 },
//                               );
//                             } else {
//                               Get.snackbar(
//                                 "Error",
//                                 "Failed to update profile ❌",
//                               );
//                             }
//                           },
//                     child: profileController.isLoading.value
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.white,
//                               ),
//                             ),
//                           )
//                         : const Text(
//                             "Save changes",
//                             style: TextStyle(fontSize: 20, color: Colors.white),
//                           ),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: CustomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onNavTap,
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:saymymeds/app/core/app_routes/app_routes.dart';
import 'package:saymymeds/app/utlies/apps_color.dart';
import 'package:saymymeds/app/widgets/BottomNav.dart';
import 'package:saymymeds/app/views/screens/home/controller/home_page_&_edit_profilecontroller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  int _currentIndex = 3;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _nameController;
  final HomePageEditProfilecontroller profileController =
      Get.find<HomePageEditProfilecontroller>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: profileController.name.value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FB),
            boxShadow: [
              BoxShadow(
                color: Color(0x26000000),
                offset: Offset(0, 2),
                blurRadius: 10,
              ),
            ],
          ),
          child: AppBar(
            leading: InkWell(
              onTap: () {
                context.pop("/");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/icons/Back_Icon.png",
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            title: Text(
              'editProfile'.tr,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 24,
                height: 1,
                color: AppColors.primary,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Image
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(() {
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (profileController.image.value.isNotEmpty
                                    ? NetworkImage(
                                        profileController.getFullImageUrl(),
                                      )
                                    : const AssetImage(
                                        'assets/images/eclipe.png',
                                      ))
                                as ImageProvider,
                    );
                  }),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.forgetPasswordOpacity,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Text(
                  'changePhoto'.tr,
                  style: const TextStyle(
                    color: AppColors.forgetPasswordOpacity,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'fullName'.tr,
                  labelStyle: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 18,
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Save button
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: profileController.isLoading.value
                        ? null
                        : () async {
                            String newName = _nameController.text.trim();
                            if (newName.isEmpty) {
                              Get.snackbar('error'.tr, 'nameCannotBeEmpty'.tr);
                              return;
                            }

                            bool success = await profileController
                                .updateProfile(
                                  newName: newName,
                                  newImage: _image?.path,
                                );

                            if (success) {
                              Get.snackbar('success'.tr, 'profileUpdated'.tr);
                              Future.delayed(
                                const Duration(milliseconds: 500),
                                () {
                                  context.go(AppRoutes.homeViewPage);
                                },
                              );
                            } else {
                              Get.snackbar(
                                'error'.tr,
                                'failedToUpdateProfile'.tr,
                              );
                            }
                          },
                    child: profileController.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'saveChanges'.tr,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              }),
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
