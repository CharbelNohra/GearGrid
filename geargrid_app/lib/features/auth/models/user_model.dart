class User {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String country;
  final String countryCode;
  final String address;
  final String phoneNumber;
  final String? avatar;
  final bool isVerified;
  final String role;

  User({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.country,
    required this.countryCode,
    required this.address,
    required this.phoneNumber,
    this.avatar,
    this.isVerified = false,
    this.role = 'client',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] ?? json;

    return User(
      id: userData['_id'] ?? userData['id'] ?? '',
      userId: userData['userId'] ?? '',
      fullName: userData['fullName'] ?? '',
      email: userData['email'] ?? '',
      country: userData['country'] ?? '',
      countryCode: userData['countryCode'] ?? '',
      address: userData['address'] ?? '',
      phoneNumber: userData['phoneNumber'] ?? '',
      avatar: userData['avatar'],
      isVerified: userData['isVerified'] ?? false,
      role: userData['role'] ?? 'client',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'country': country,
      'countryCode': countryCode,
      'address': address,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'isVerified': isVerified,
      'role': role
    };
  }

  User copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? email,
    String? country,
    String? countryCode,
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
      countryCode: countryCode ?? this.countryCode,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      isVerified: isVerified ?? this.isVerified,
      role: role ?? this.role
    );
  }

  String get displayName => fullName.isNotEmpty ? fullName : email;

  String? get avatarUrl {
    if (avatar == null || avatar!.isEmpty) return null;

    if (avatar!.startsWith('http')) return avatar;

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