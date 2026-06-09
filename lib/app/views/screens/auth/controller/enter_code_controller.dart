// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;

// class EnterCodeController extends GetxController {
//   final RxString otp = ''.obs;
//   final RxBool isCodeFilled = false.obs;
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   // ✅ Verify OTP and get reset_token
//   Future<void> verifyCode(String email, BuildContext context) async {
//     if (otp.value.length != 6) {
//       errorMessage.value = 'Please enter a valid 6-digit OTP';
//       return;
//     }

//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final response = await http.post(
//         Uri.parse('http://10.10.7.24:8002/account/reset-password-otp/'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'otp': otp.value}),
//       );

//       print('✅ Verify Response: Status ${response.statusCode}');
//       print('✅ Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         // ✅ Extract reset_token from response
//         final responseData = jsonDecode(response.body);
//         final resetToken = responseData['reset_token'] as String?;

//         print('🎫 Extracted reset_token: $resetToken');

//         if (resetToken == null || resetToken.isEmpty) {
//           errorMessage.value = 'Failed to get reset token from server';
//           isLoading.value = false;
//           return;
//         }

//         if (context.mounted) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('OTP verified successfully!'),
//                 backgroundColor: Colors.green,
//               ),
//             );

//             // ✅ Navigate with reset_token
//             print('🚀 Navigating to NewPassword with token: $resetToken');
//             context.go('/newPassword', extra: resetToken);
//           });
//         }
//       } else {
//         String userError = _parseFastApiError(response.body);
//         errorMessage.value = userError.isNotEmpty
//             ? userError
//             : 'Verification failed. Please try again.';

//         if (context.mounted) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(errorMessage.value),
//                 backgroundColor: Colors.red,
//                 duration: const Duration(seconds: 3),
//               ),
//             );
//           });
//         }
//       }
//     } catch (e) {
//       errorMessage.value = 'Network error. Please check your connection.';
//       print('❌ Verify Error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ✅ Resend OTP
//   Future<void> resendCode(String email, BuildContext context) async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final response = await http.post(
//         Uri.parse('http://10.10.7.24:8002/account/send-reset-password-email/'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email}),
//       );

//       print('✅ Resend Response: Status ${response.statusCode}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         otp.value = '';
//         isCodeFilled.value = false;

//         if (context.mounted) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('New OTP sent to your email!'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           });
//         }
//       } else {
//         String userError = _parseFastApiError(response.body);
//         errorMessage.value = userError.isNotEmpty
//             ? userError
//             : 'Failed to resend OTP. Please try again.';

//         if (context.mounted) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(errorMessage.value),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//           });
//         }
//       }
//     } catch (e) {
//       errorMessage.value = 'Network error. Please try again.';
//       print('❌ Resend Error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   String _parseFastApiError(String body) {
//     try {
//       final Map<String, dynamic> jsonBody = jsonDecode(body);

//       if (jsonBody.containsKey('non_field_errors')) {
//         final errors = jsonBody['non_field_errors'];
//         if (errors is List && errors.isNotEmpty) {
//           return errors.first.toString();
//         }
//       }

//       if (jsonBody.containsKey('detail')) {
//         final detail = jsonBody['detail'];
//         if (detail is String) {
//           return detail;
//         } else if (detail is List && detail.isNotEmpty) {
//           final firstError = detail.firstWhere(
//             (e) => e['msg'] != null,
//             orElse: () => null,
//           );
//           return firstError?['msg'] ?? 'Invalid request';
//         }
//       }

//       for (var key in jsonBody.keys) {
//         if (jsonBody[key] is List && (jsonBody[key] as List).isNotEmpty) {
//           return '${key}: ${jsonBody[key][0]}';
//         }
//       }
//     } catch (e) {
//       print('❌ Error parsing API response: $e');
//       return '';
//     }
//     return '';
//   }

//   void updateOtp(String value) {
//     otp.value = value;
//     isCodeFilled.value = value.length == 6;
//     if (errorMessage.value.isNotEmpty) {
//       errorMessage.value = '';
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:saymymeds/app/core/consants/api_constants.dart';

class EnterCodeController extends GetxController {
  final RxString otp = ''.obs;
  final RxBool isCodeFilled = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Define the base URL
  final String baseUrl = ApiConstants.baseUrl;
  // ✅ Verify OTP and get reset_token
  Future<void> verifyCode(String email, BuildContext context) async {
    if (otp.value.length != 6) {
      errorMessage.value = 'Please enter a valid 6-digit OTP';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/account/reset-password-otp/',
        ), // Use the baseUrl variable
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp.value}),
      );

      print('✅ Verify Response: Status ${response.statusCode}');
      print('✅ Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // ✅ Extract reset_token from response
        final responseData = jsonDecode(response.body);
        final resetToken = responseData['reset_token'] as String?;

        print('🎫 Extracted reset_token: $resetToken');

        if (resetToken == null || resetToken.isEmpty) {
          errorMessage.value = 'Failed to get reset token from server';
          isLoading.value = false;
          return;
        }

        if (context.mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('OTP verified successfully!'),
                backgroundColor: Colors.green,
              ),
            );

            // ✅ Navigate with reset_token
            print('🚀 Navigating to NewPassword with token: $resetToken');
            context.go('/newPassword', extra: resetToken);
          });
        }
      } else {
        String userError = _parseFastApiError(response.body);
        errorMessage.value = userError.isNotEmpty
            ? userError
            : 'Verification failed. Please try again.';

        if (context.mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage.value),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          });
        }
      }
    } catch (e) {
      errorMessage.value = 'Network error. Please check your connection.';
      print('❌ Verify Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Resend OTP
  Future<void> resendCode(String email, BuildContext context) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/account/send-reset-password-email/',
        ), // Use the baseUrl variable
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      print('✅ Resend Response: Status ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        otp.value = '';
        isCodeFilled.value = false;

        if (context.mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('New OTP sent to your email!'),
                backgroundColor: Colors.green,
              ),
            );
          });
        }
      } else {
        String userError = _parseFastApiError(response.body);
        errorMessage.value = userError.isNotEmpty
            ? userError
            : 'Failed to resend OTP. Please try again.';

        if (context.mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage.value),
                backgroundColor: Colors.orange,
              ),
            );
          });
        }
      }
    } catch (e) {
      errorMessage.value = 'Network error. Please try again.';
      print('❌ Resend Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _parseFastApiError(String body) {
    try {
      final Map<String, dynamic> jsonBody = jsonDecode(body);

      if (jsonBody.containsKey('non_field_errors')) {
        final errors = jsonBody['non_field_errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }

      if (jsonBody.containsKey('detail')) {
        final detail = jsonBody['detail'];
        if (detail is String) {
          return detail;
        } else if (detail is List && detail.isNotEmpty) {
          final firstError = detail.firstWhere(
            (e) => e['msg'] != null,
            orElse: () => null,
          );
          return firstError?['msg'] ?? 'Invalid request';
        }
      }

      for (var key in jsonBody.keys) {
        if (jsonBody[key] is List && (jsonBody[key] as List).isNotEmpty) {
          return '${key}: ${jsonBody[key][0]}';
        }
      }
    } catch (e) {
      print('❌ Error parsing API response: $e');
      return '';
    }
    return '';
  }

  void updateOtp(String value) {
    otp.value = value;
    isCodeFilled.value = value.length == 6;
    if (errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
    }
  }
}
