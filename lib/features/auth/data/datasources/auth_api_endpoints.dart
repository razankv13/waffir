class AuthApiEndpoints {
  AuthApiEndpoints._();

  // Phone OTP (Supabase OTP flow via backend)
  static const String sendOtp = '/auth/otp/send';
  static const String verifyOtp = '/auth/otp/verify';

  // Email/password
  static const String signUp = '/auth/signup';
  static const String signIn = '/auth/login';
  static const String resetPassword = '/auth/password/reset';

  // OAuth (Google/Apple) via backend token exchange
  static const String googleSignIn = '/auth/oauth/google';
  static const String appleSignIn = '/auth/oauth/apple';

  // Profile
  static const String getProfile = '/auth/profile';
  static const String upsertProfile = '/auth/profile';
}

