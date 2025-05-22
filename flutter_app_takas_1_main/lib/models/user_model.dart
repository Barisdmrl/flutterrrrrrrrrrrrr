class User {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  String? profileImage;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
    };
  }
} 