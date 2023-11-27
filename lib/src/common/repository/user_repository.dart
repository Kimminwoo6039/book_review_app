import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../model/user_model.dart';

class UserRepository {
  FirebaseFirestore db;

  UserRepository(this.db);

  Future<UserModel?> findUserOne(String uid) async {
    try {
      var userInfo =
          await db.collection('users').where('uid', isEqualTo: uid).get();
      if (userInfo.docs.isEmpty) {
        return null;
      } else {
        return UserModel.fromJson(userInfo.docs.first.data());
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> joinUser(UserModel userModel) async {
    try {
      db.collection('users').add(userModel.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<UserModel>> allUserInfos(List<String> uids) async {
    var doc = await db.collection("users").where("uid", whereIn: uids).get();
    if (doc.docs.isEmpty) {
      return [];
    } else {
      return doc.docs
          .map<UserModel>((data) => UserModel.fromJson(data.data()))
          .toList();
    }
  }

  Future<bool> followEvent(bool isFollow,String targetUid, String myUid) async {
    try {
      // 2 가지 업데이트 ( 트랜잭션 실행 필요 )
      final batch = db.batch();

      // Type1 . 상대방 팔로워에 내가 들어가는건다..
      var targetUserDoc =
      await db.collection("users").where("uid", isEqualTo: targetUid).get();
      UserModel targetUserInfo = UserModel.fromJson(targetUserDoc.docs.first.data());
      var followers = targetUserInfo.followers ?? []; // 최초사람

      if (isFollow) {
      followers.add(myUid);
      } else {
      followers.remove(myUid);
      }

      var targetRef = db.collection("users").doc(targetUserDoc.docs.first.id);
      batch.update(targetRef, {'followers': followers , 'followersCount' : followers.length});

      // Type1 . 내 팔로워에 상대방이 들어간다...
      var myUserDoc =
      await db.collection("users").where("uid", isEqualTo: myUid).get();
      UserModel myUserInfo = UserModel.fromJson(myUserDoc.docs.first.data());
      var followings = myUserInfo.followings ?? [];

      if (isFollow) {
      followings.add(targetUid);
      } else {
      followings.remove(targetUid);
      }

      var MyRef = db.collection("users").doc(myUserDoc.docs.first.id);
      batch.update(MyRef, {'followings': followings , 'followingsCount' : followings.length});

      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

    Future<void> updateReviewCounts(String uid,int reviewCount) async {
      var targetUserDoc =await db.collection("users").where("uid",isEqualTo: uid).get();
      await db.collection("users").doc(targetUserDoc.docs.first.id).update({'reviewCount':reviewCount});
    }
    
    Future<List<UserModel>> loadTopReviewerData() async {
      var doc = await db.collection("users").orderBy("followersCount",descending: true).limit(10).get();
      if (doc.docs.isNotEmpty) {
        return doc.docs.map<UserModel>((e) => UserModel.fromJson(e.data())).toList();
      }
      return [];
    }

  /*
  Future<bool> unfollow(String targetUid, String myUid) async {
    try {
      // 2 가지 업데이트 ( 트랜잭션 실행 필요 )
      final batch = db.batch();

      // Type1 . 상대방 팔로워에 내가 들어가는건다..
      var targetUserDoc =
      await db.collection("users").where("uid", isEqualTo: targetUid).get();
      UserModel targetUserInfo =
      UserModel.fromJson(targetUserDoc.docs.first.data());
      var followers = targetUserInfo.followers ?? []; // 최초사람
      followers.remove(myUid);
      var targetRef = db.collection("users").doc(targetUserDoc.docs.first.id);
      batch.update(targetRef, {'followers': followers});

      // Type1 . 내 팔로워에 상대방이 들어간다...
      var myUserDoc =
      await db.collection("users").where("uid", isEqualTo: myUid).get();
      UserModel myUserInfo = UserModel.fromJson(myUserDoc.docs.first.data());
      var followings = myUserInfo.followings ?? [];
      followings.remove(targetUid);
      var MyRef = db.collection("users").doc(myUserDoc.docs.first.id);
      batch.update(MyRef, {'followings': followings});

      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> follow(String targetUid, String myUid) async {
    try {
      // 2 가지 업데이트 ( 트랜잭션 실행 필요 )
      final batch = db.batch();

      // Type1 . 상대방 팔로워에 내가 들어가는건다..
      var targetUserDoc =
          await db.collection("users").where("uid", isEqualTo: targetUid).get();
      UserModel targetUserInfo =
          UserModel.fromJson(targetUserDoc.docs.first.data());
      var followers = targetUserInfo.followers ?? []; // 최초사람
      followers.add(myUid);
      var targetRef = db.collection("users").doc(targetUserDoc.docs.first.id);
      batch.update(targetRef, {'followers': followers});

      // Type1 . 내 팔로워에 상대방이 들어간다...
      var myUserDoc =
          await db.collection("users").where("uid", isEqualTo: myUid).get();
      UserModel myUserInfo = UserModel.fromJson(myUserDoc.docs.first.data());
      var followings = myUserInfo.followings ?? [];
      followings.add(targetUid);
      var MyRef = db.collection("users").doc(myUserDoc.docs.first.id);
      batch.update(MyRef, {'followings': followings});

      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

   */
}
