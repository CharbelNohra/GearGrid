class User {
  final String id; // MongoDB _id
  final String userId; // nanoid(8)
  final String fullName;
  final String email;
  final String country;
  final String address;
  final String phoneNumber;
  final String? avatar;
  final bool isVerified;
  final String role; // "client" or "admin"
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.country,
    required this.address,
    required this.phoneNumber,
    this.avatar,
    this.isVerified = false,
    this.role = 'client',
    this.createdAt,
    this.updatedAt,
  });

  // Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    // Handle nested user data (in case the API returns {user: {...}, token: "..."})
    final userData = json['user'] ?? json;

    return User(
      id: userData['_id'] ?? userData['id'] ?? '',
      userId: userData['userId'] ?? '',
      fullName: userData['fullName'] ?? '',
      email: userData['email'] ?? '',
      country: userData['country'] ?? '',
      address: userData['address'] ?? '',
      phoneNumber: userData['phoneNumber'] ?? '',
      avatar: userData['avatar'],
      isVerified: userData['isVerified'] ?? false,
      role: userData['role'] ?? 'client',
      createdAt:
          userData['createdAt'] != null
              ? DateTime.tryParse(userData['createdAt'])
              : null,
      updatedAt:
          userData['updatedAt'] != null
              ? DateTime.tryParse(userData['updatedAt'])
              : null,
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'country': country,
      'address': address,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'isVerified': isVerified,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method for updating user data
  User copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? email,
    String? country,
    String? address,
    String? phoneNumber,
    String? avatar,
    bool? isVerified,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      country: country ?? this.country,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      isVerified: isVerified ?? this.isVerified,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get display name
  String get displayName => fullName.isNotEmpty ? fullName : email;

  // Get avatar URL (if it's a relative path, make it absolute)
  String? get avatarUrl {
    if (avatar == null || avatar!.isEmpty) return null;

    // If avatar starts with http, it's already a full URL
    if (avatar!.startsWith('http')) return avatar;

    // Otherwise, prepend base URL (adjust this to match your backend)
    return 'http://10.0.2.2:3000/$avatar';
  }

  @override
  String toString() {
    return 'User{id: $id, userId: $userId, fullName: $fullName, email: $email, role: $role, isVerified: $isVerified}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}