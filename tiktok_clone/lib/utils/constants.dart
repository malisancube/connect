class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:3000/api';
  // Change to your Railway URL when deployed:
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
