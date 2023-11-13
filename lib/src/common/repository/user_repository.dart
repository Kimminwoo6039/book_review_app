
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../model/user_model.dart';

class UserRepository {
  FirebaseFirestore db;

  UserRepository(this.db);


  Future<UserModel?> findUserOne(String uid) async {
    try {
      var userInfo = await db.collection('users').where('uid', isEqualTo: uid).get();
     if (userInfo.docs.isEmpty) {
       return null;
     } else {
       return UserModel.fromJson(userInfo.docs.first.data());
     }
    } catch (e) {
      return null;
    }
  }
}