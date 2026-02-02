class AppConstants {
  // API Configuration
  // For Android Emulator (use 10.0.2.2 instead of localhost):
  static const String apiBaseUrl = 'http://10.0.2.2:3000/api';

  // For Physical Device (use your computer's IP address):
  // static const String apiBaseUrl = 'http://192.168.1.XXX:3000/api';

  // For Production (Railway deployment):
  // static const String apiBaseUrl = 'https://your-app.railway.app/api';

  // Endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String userProfile = '/users';
  static const String postsFeed = '/posts/feed';
  static const String postsCreate = '/posts';
  static const String videoUpload = '/videos/upload';

  // Local Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUsername = 'username';

  // App Config
  static const int feedPageSize = 20;
  static const int maxVideoLength = 60; // seconds
  static const int videoQuality = 720; // 720p
}
