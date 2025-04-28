import 'package:cloud_firestore/cloud_firestore.dart';

class TaskResponse {
  final String id;
  final String title;
  final String description;
  final String ownerId;
  final String createdBy;
  final List<String> sharedWithUserIds;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime eventDateTime;

  TaskResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.createdBy,
    required this.sharedWithUserIds,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    required this.eventDateTime,
  });

  // Factory constructor to create a TaskResponse from Firestore document
  factory TaskResponse.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskResponse(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ownerId: data['ownerId'] ?? '',
      createdBy: data['createdBy'] ?? '',
      sharedWithUserIds: List<String>.from(data['sharedWithUserIds'] ?? []),
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      eventDateTime: (data['eventDateTime'] as Timestamp).toDate(),
    );
  }

  // Method to convert the task into a map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ownerId': ownerId,
      'createdBy': createdBy,
      'sharedWithUserIds': sharedWithUserIds,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'eventDateTime': eventDateTime,
    };
  }

  TaskResponse copyWith({
    String? id,
    String? title,
    String? description,
    String? ownerId,
    String? createdBy,
    List<String>? sharedWithUserIds,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? eventDateTime,
  }) {
    return TaskResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      createdBy: createdBy ?? this.createdBy,
      sharedWithUserIds: sharedWithUserIds ?? this.sharedWithUserIds,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      eventDateTime: eventDateTime ?? this.eventDateTime,
    );
  }
}
