import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static const String mongoUrl = "mongodb+srv://lisakhan1952_db_user:SKRESSlUec6qKrmL@cluster0.s3lgd1z.mongodb.net/cms_db?retryWrites=true&w=majority";
  static dynamic db;
  static dynamic userCollection;
  
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
}
