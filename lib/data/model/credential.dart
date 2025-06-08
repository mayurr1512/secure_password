class Credential {
  final num? id;
  final String siteName;
  final String username;
  final String password;
  final String category;

  Credential({
    this.id,
    required this.siteName,
    required this.username,
    required this.password,
    required this.category,
  });

  Credential copyWith({
    int? id,
    String? siteName,
    String? username,
    String? password,
    String? category,
  }) {
    return Credential(
      id: id ?? this.id,
      siteName: siteName ?? this.siteName,
      username: username ?? this.username,
      password: password ?? this.password,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'siteName': siteName,
      'username': username,
      'password': password,
      'category': category,
    };
    if (id != null) {
      map['id'] = id; // Only include if it's not null
    }
    return map;
  }

  factory Credential.fromMap(Map<String, dynamic> map) {
    return Credential(
      id: map['id'] as int?,
      siteName: map['siteName'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      category: map['category'] as String,
    );
  }
}