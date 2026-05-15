import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static const String mongoUrl = "mongodb+srv://lisakhan1952_db_user:SKRESSlUec6qKrmL@cluster0.s3lgd1z.mongodb.net/cms_db?retryWrites=true&w=majority";
  static dynamic db;
  static dynamic userCollection;
  static dynamic complaintCollection;
  static dynamic noticeCollection;
  
  // Awesome Feature: Global User Session
  static Map<String, dynamic>? currentUser;

  static Future<void> connect() async {
    if (kIsWeb) {
      log("MONGODB ERROR: Web not supported.");
      return;
    }
    try {
      db = await Db.create(mongoUrl);
      await db.open().timeout(const Duration(seconds: 15));
      if (db.isConnected) {
        userCollection = db.collection("users");
        complaintCollection = db.collection("complaints");
        noticeCollection = db.collection("notices");
        log("SUCCESS: Database Connected.");
      }
    } catch (e) {
      log("CRITICAL ERROR: $e");
      db = null;
    }
  }

  static Future<Map<String, dynamic>?> login(String email, String password) async {
    if (db == null || !db.isConnected) return null;
    try {
      final user = await userCollection.findOne(where.eq('email', email).eq('password', password));
      if (user != null) {
        currentUser = user; // Save session
        log("SESSION START: ${user['email']}");
      }
      return user;
    } catch (e) {
      log("LOGIN ERROR: $e");
      return null;
    }
  }

  static Future<bool> register(String name, String email, String password, String role) async {
    if (db == null || !db.isConnected) return false;
    try {
      var existingUser = await userCollection.findOne(where.eq('email', email));
      if (existingUser != null) return false;

      await userCollection.insertOne(<String, dynamic>{
        "name": name,
        "email": email,
        "password": password,
        "role": role,
        "createdAt": DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      log("REGISTER ERROR: $e");
      return false;
    }
  }

  static void logout() {
    currentUser = null;
    log("SESSION END: User logged out.");
  }

  // --- Complaint Operations ---
  static Future<bool> submitComplaint(Map<String, dynamic> data) async {
    try {
      await complaintCollection.insertOne(data);
      return true;
    } catch (e) {
      log("COMPLAINT ERROR: $e");
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getMyComplaints(String email) async {
    return await complaintCollection.find(where.eq('userEmail', email).sortBy('createdAt', descending: true)).toList();
  }

  static Future<List<Map<String, dynamic>>> getAllComplaints({String? dept}) async {
    var query = dept != null && dept != "General" ? where.eq('department', dept) : where;
    return await complaintCollection.find(query.sortBy('createdAt', descending: true)).toList();
  }

  static Future<void> updateComplaintStatus(ObjectId id, String status, {String? remarks}) async {
    var update = modify.set('status', status);
    if (remarks != null) update.set('adminRemarks', remarks);
    await complaintCollection.update(where.id(id), update);
  }

  // --- Notice Operations ---
  static Future<List<Map<String, dynamic>>> getNotices() async {
    return await noticeCollection.find(where.sortBy('createdAt', descending: true)).toList();
  }

  static Future<void> addNotice(String title, String body) async {
    await noticeCollection.insertOne({
      "title": title,
      "body": body,
      "createdAt": DateTime.now().toIso8601String(),
    });
  }

  // --- Stats ---
  static Future<Map<String, int>> getStats(String? email, {String? role, String? dept}) async {
    var query = where;
    if (role == 'Student' && email != null) {
      query = where.eq('userEmail', email);
    } else if ((role == 'Staff' || role == 'Teacher') && dept != null && dept != "General") {
      query = where.eq('department', dept);
    }

    int total = await complaintCollection.count(query);
    int pending = await complaintCollection.count(query.clone().eq('status', 'Pending'));
    int solved = await complaintCollection.count(query.clone().eq('status', 'Resolved'));
    return {"total": total, "pending": pending, "solved": solved};
  }

  static Future<int> getUserCount() async {
    return await userCollection.count();
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await userCollection.find().toList();
  }

  // --- Analytics & Insights ---
  static Future<Map<String, dynamic>> getAdvancedAnalytics() async {
    int totalUsers = await userCollection.count();
    int totalComplaints = await complaintCollection.count();
    int resolved = await complaintCollection.count(where.eq('status', 'Resolved'));
    
    // Calculate Resolution Rate
    double rate = totalComplaints > 0 ? (resolved / totalComplaints) * 100 : 0;
    
    return {
      "users": totalUsers,
      "complaints": totalComplaints,
      "resolutionRate": rate.toStringAsFixed(1),
      "dbLatency": "Healthy", // Simulated for UI
    };
  }

  static Future<void> updateProfile(ObjectId id, String name, String password) async {
    await userCollection.update(where.id(id), modify.set('name', name).set('password', password));
    // Update local session
    if (currentUser != null && currentUser!['_id'] == id) {
      currentUser!['name'] = name;
      currentUser!['password'] = password;
    }
  }
}
