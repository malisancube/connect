class Post {
  final int id;
  final int userId;
  final String videoUrl;
  final String? thumbnailUrl;
  final String? caption;
  final String? musicName;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final DateTime createdAt;

  // User info
  final String? username;
  final String? displayName;
  final String? profileImageUrl;

  // Local state
  bool isLiked;

  Post({
    required this.id,
    required this.userId,
    required this.videoUrl,
    this.thumbnailUrl,
    this.caption,
    this.musicName,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.viewsCount = 0,
    required this.createdAt,
    this.username,
    this.displayName,
    this.profileImageUrl,
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['user_id'],
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      caption: json['caption'],
      musicName: json['music_name'],
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      sharesCount: json['shares_count'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      username: json['username'],
      displayName: json['display_name'],
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'caption': caption,
      'music_name': musicName,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'views_count': viewsCount,
      'created_at': createdAt.toIso8601String(),
      'username': username,
      'display_name': displayName,
      'profile_image_url': profileImageUrl,
    };
  }

  Post copyWith({
    bool? isLiked,
    int? likesCount,
    int? commentsCount,
  }) {
    return Post(
      id: id,
      userId: userId,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      caption: caption,
      musicName: musicName,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount,
      viewsCount: viewsCount,
      createdAt: createdAt,
      username: username,
      displayName: displayName,
      profileImageUrl: profileImageUrl,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
