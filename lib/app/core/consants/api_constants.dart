class ApiConstants {
  static const String baseUrl =
      "https://api.saymymeds.com";

  /* auth start here  */
  static const String login = "$baseUrl/account/login/"; // Corrected the URL
  static const String signup = "$baseUrl/account/register/";
  static const String otpVerify = "$baseUrl/account/verify-otp/";
  static const String resendOtp = "$baseUrl/account/resend-otp/";
  static const String forgetPassword =
      "$baseUrl/account/send-reset-password-email/";
  static const String resetPasswordOtp =
      "$baseUrl/api/user/reset-password-otp/";
  static const String token = "";
  /* auth end here  */
}
