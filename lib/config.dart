class Config {
  // Base URL for Django backend
  // For Android emulator, use: http://10.0.2.2:8000
  // For web/chrome, use: http://127.0.0.1:8000 or http://localhost:8000
  static const String baseUrl = 'http://127.0.0.1:8000';
  
  static String get authRegister => '$baseUrl/auth/register/';
  static String get authLogin => '$baseUrl/auth/login/';
  static String get authLogout => '$baseUrl/auth/logout/';
  static String get productEntryJson => '$baseUrl/json/';
  static String get proxyImage => '$baseUrl/proxy-image/';
}

