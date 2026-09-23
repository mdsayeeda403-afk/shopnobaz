import 'package:cloud_firestore/cloud_firestore.dart';

/// ইউজারের role - লেখক সব করতে পারবে (পড়া + লেখা), পাঠক শুধু পড়বে
enum UserRole { writer, reader }

class AppUser {
  final String uid;
  final String name;
  final String email;
  final UserRole role;
  final String bio;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.bio = '',
    required this.createdAt,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: (map['role'] == 'writer') ? UserRole.writer : UserRole.reader,
      bio: map['bio'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role == UserRole.writer ? 'writer' : 'reader',
      'bio': bio,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
