// lib/app/core/consants/api_constants.dart

class ApiConstants {
  static const String baseUrl = "https://api.saymymeds.com";

  /* auth start here  */
  static const String login = "$baseUrl/account/login/";
  static const String signup = "$baseUrl/account/register/";
  static const String otpVerify = "$baseUrl/account/verify-otp/";
  static const String resendOtp = "$baseUrl/account/resend-otp/";
  static const String forgetPassword = "$baseUrl/account/send-reset-password-email/";
  static const String resetPasswordOtp = "$baseUrl/api/user/reset-password-otp/";
  static const String deleteAccount = "$baseUrl/accounts/user/delete-account/";

  /* API Endpoints */
  static const String medications = "$baseUrl/api/core/medications/";
  static const String aiAnalysis = "$baseUrl/api/core/ai-analysis/";
  static const String saveAiAnalysis = "$baseUrl/api/core/save-ai-analysis/";
  static const String notes = "$baseUrl/api/core/notes/";

  // ✅ সঠিক endpoint (এটা কাজ করছে)
  static const String userProfile = "$baseUrl/account/profile/";

  static const String token = "";
}