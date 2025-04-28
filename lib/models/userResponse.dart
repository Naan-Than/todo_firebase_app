import 'package:cloud_firestore/cloud_firestore.dart';

class UserResponse {
  final String id;
  final String displayName;
  final String email;
  final Timestamp createdAt;

  UserResponse({
    required this.id,
    required this.displayName,
    required this.email,
    required this.createdAt,
  });

  factory UserResponse.fromFirestore(Map<String, dynamic> doc, String docId) {
    return UserResponse(
      id: docId, // document id separately
      displayName: doc['displayName'] ?? '',
      email: doc['email'] ?? '',
      createdAt: doc['createdAt'] ?? Timestamp.now(),
    );
  }

  // Convert the UserResponse object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'displayName': displayName,
      'email': email,
      'createdAt': createdAt,
    };
  }

  // For better print output
  @override
  String toString() {
    return 'UserResponse(id: $id,displayName: $displayName, email: $email, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserResponse &&
              runtimeType == other.runtimeType &&
              id == other.id &&

              displayName == other.displayName &&
              email == other.email &&
              createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^  displayName.hashCode ^ email.hashCode ^ createdAt.hashCode;
}