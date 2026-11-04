class User {
  final int id;
  final String name, username, email, phone, website, companyName, city;
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.companyName,
    required this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    website: json['website'] ?? '',
    companyName: json['company']?['name'] ?? '',
    city: json['address']?['city'] ?? '',
  );
  String get initial => name.isEmpty ? '?' : name.trim()[0].toUpperCase();
}
