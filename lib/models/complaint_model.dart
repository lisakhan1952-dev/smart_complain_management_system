import 'package:mongo_dart/mongo_dart.dart';

class ComplaintModel {
  final ObjectId id;
  final String userEmail;
  final String userName;
  final String category;
  final String description;
  final String status; 
  final String priority; // Low, Medium, High
  final String? adminRemarks;
  final DateTime createdAt;

  ComplaintModel({
    required this.id,
    required this.userEmail,
    required this.userName,
    required this.category,
    required this.description,
    required this.status,
    required this.priority,
    this.adminRemarks,
    required this.createdAt,
  });

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      id: map['_id'],
      userEmail: map['userEmail'],
      userName: map['userName'],
      category: map['category'],
      description: map['description'],
      status: map['status'],
      priority: map['priority'] ?? 'Medium',
      adminRemarks: map['adminRemarks'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userEmail': userEmail,
      'userName': userName,
      'category': category,
      'description': description,
      'status': status,
      'priority': priority,
      'adminRemarks': adminRemarks,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
