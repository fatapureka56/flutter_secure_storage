class Post {
  final int userId, id;
  final String title, body;
  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });
  factory Post.fromJson(Map<String, dynamic> json) => Post(
    userId: json['userId'] ?? 0,
    id: json['id'] ?? 0,
    title: json['title'] ?? '',
    body: json['body'] ?? '',
  );
}
