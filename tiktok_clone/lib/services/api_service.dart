import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _authToken;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(AppConstants.keyAuthToken);
  }

  Future<void> saveToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyAuthToken, token);
  }

  Future<void> clearToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyAuthToken);
  }

  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  // Auth APIs
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}${AppConstants.authRegister}'),
      headers: _getHeaders(includeAuth: false),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'displayName': displayName,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Registration failed');
    }
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}${AppConstants.authLogin}'),
      headers: _getHeaders(includeAuth: false),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Login failed');
    }
  }

  // Posts APIs
  Future<List<Post>> getFeed({int limit = 20, int offset = 0}) async {
    final response = await http.get(
      Uri.parse('${AppConstants.apiBaseUrl}${AppConstants.postsFeed}?limit=$limit&offset=$offset'),
      headers: _getHeaders(includeAuth: false),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load feed');
    }
  }

  Future<Post> createPost({
    required String videoUrl,
    String? thumbnailUrl,
    String? caption,
    String? musicName,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}${AppConstants.postsCreate}'),
      headers: _getHeaders(),
      body: jsonEncode({
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        'caption': caption,
        'musicName': musicName,
      }),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create post');
    }
  }

  Future<void> likePost(int postId) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}/posts/$postId/like'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like post');
    }
  }

  Future<void> unlikePost(int postId) async {
    final response = await http.delete(
      Uri.parse('${AppConstants.apiBaseUrl}/posts/$postId/like'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unlike post');
    }
  }

  // Video Upload
  Future<String> uploadVideo(File videoFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.apiBaseUrl}${AppConstants.videoUpload}'),
    );

    request.headers['Authorization'] = 'Bearer $_authToken';
    request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseData);
      return data['videoUrl'];
    } else {
      throw Exception('Failed to upload video');
    }
  }

  // User APIs
  Future<User> getUserProfile(String username) async {
    final response = await http.get(
      Uri.parse('${AppConstants.apiBaseUrl}${AppConstants.userProfile}/$username'),
      headers: _getHeaders(includeAuth: false),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<void> followUser(String username) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}${AppConstants.userProfile}/$username/follow'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to follow user');
    }
  }

  Future<void> unfollowUser(String username) async {
    final response = await http.delete(
      Uri.parse('${AppConstants.apiBaseUrl}${AppConstants.userProfile}/$username/follow'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unfollow user');
    }
  }
}
