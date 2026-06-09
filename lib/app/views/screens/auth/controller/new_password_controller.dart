import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:saymymeds/app/core/consants/api_constants.dart';

class NewPasswordController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final String baseUrl = ApiConstants.baseUrl;

  Future<bool> setNewPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    errorMessage.value = '';

    if (resetToken.isEmpty) {
      errorMessage.value = 'Reset token is missing';
      return false;
    }
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      errorMessage.value = 'Password fields cannot be empty';
      return false;
    }
    if (newPassword != confirmPassword) {
      errorMessage.value = 'Passwords do not match';
      return false;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('$baseUrl/account/set-new-password/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reset_token': resetToken,
          'new_password': newPassword,
          'new_password2': confirmPassword,
        }),
      );

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // ── Parse error from backend ──────────────────────────────────
      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage.value = _extractErrorMessage(data) ??
            'Failed to reset password (${response.statusCode})';
      } catch (_) {
        errorMessage.value =
        'Failed to reset password (${response.statusCode})';
      }

      return false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: ${e.toString()}';
      return false;
    }
  }

  /// Tries all common backend error-message shapes.
  String? _extractErrorMessage(Map<String, dynamic> data) {
    // Direct string keys
    for (final key in ['message', 'msg', 'detail', 'error']) {
      if (data[key] is String && (data[key] as String).isNotEmpty) {
        return data[key] as String;
      }
    }

    // non_field_errors list
    final nfe = data['non_field_errors'];
    if (nfe is List && nfe.isNotEmpty) return nfe.first.toString();

    // detail as list of validation dicts (FastAPI / DRF style)
    final detail = data['detail'];
    if (detail is List && detail.isNotEmpty) {
      final first = detail.firstWhere(
            (e) => e is Map && e['msg'] != null,
        orElse: () => null,
      );
      if (first != null) return first['msg'].toString();
    }

    // errors sub-object
    final errors = data['errors'];
    if (errors is Map) {
      for (final key in [
        'non_field_errors',
        'new_password',
        'reset_token',
        'email',
        'detail',
      ]) {
        final v = errors[key];
        if (v is List && v.isNotEmpty) return v.first.toString();
        if (v is String && v.isNotEmpty) return v;
      }
    }

    return null;
  }
}