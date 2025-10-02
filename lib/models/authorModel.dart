class Author {
  final int id;
  final String username;
  final String slug;
  final String email;
  final String? avatar;
  final String? coverImage;
  final String? aboutMe;
  final String? lastSeen;

  Author({
    required this.id,
    required this.username,
    required this.slug,
    required this.email,
    this.avatar,
    this.coverImage,
    this.aboutMe,
    this.lastSeen,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      username: json['username'] ?? '',
      slug: json['slug'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      coverImage: json['cover_image'],
      aboutMe: json['about_me'],
      lastSeen: json['last_seen'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'slug': slug,
        'email': email,
        'avatar': avatar,
        'cover_image': coverImage,
        'about_me': aboutMe,
        'last_seen': lastSeen,
      };
}
