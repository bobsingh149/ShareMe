import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta/models/user.dart';

class UserAuth {
  final _auth = FirebaseAuth.instance;

  Future<String> signin(
      {required String email, required String password}) async {
    String res = '';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'y';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> signup(UserModel user) async {
    String res = '';
    try {
      final data = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      final String uid = data.user!.uid;
      final snap = await FirebaseStorage.instance
          .ref()
          .child('users')
          .child(uid)
          .putData(user.profilepic);

      print('task###################');

      final String link = await snap.ref.getDownloadURL();

      print('link');
      print(link.toString());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(data.user?.uid)
          .set(user.getMap(link));

      await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      res = 'y';
    } catch (err) {
      print(err.toString());
      res = err.toString();
    }

    return res;
  }
}

class FirebaseHelper {
  static String getid() {
    final auth = FirebaseAuth.instance;
    return auth.currentUser!.uid;
  }

  static Future<void> addwithid(
      {required String collectionpath,
      required String itemid,
      required Map<String, dynamic> data}) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection(collectionpath).doc(itemid).set(data);
  }

  static Future<void> add(
      {required String collectionpath,
      required Map<String, Object> data}) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection(collectionpath).add(data);
  }

  static Future<void> delete(
      {required String collectionpath, required String itemid}) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection(collectionpath).doc(itemid).delete();
  }

  static Future<List<QueryDocumentSnapshot>> getlist(
      {required String collectionpath}) async {
    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore.collection(collectionpath).get();

    return snapshot.docs;
  }

  static getitem(
      {required String collectionpath, required String itemid}) async {
    final firestore = FirebaseFirestore.instance;

    final docdata =
        await firestore.collection(collectionpath).doc(itemid).get();

    return docdata.data();
  }

  static Future<String> getitemfield(
      {required String collectionpath,
      required String itemid,
      required String field}) async {
    final firestore = FirebaseFirestore.instance;

    final docdata =
        await firestore.collection(collectionpath).doc(itemid).get();
    print(docdata.get(field));
    return docdata.get(field);
  }

  static Future<void> update(
      {required String collectionpath,
      required String itemid,
      required Map<String, Object> data}) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection(collectionpath).doc(itemid).update(data);
  }

  static Future<void> bukcetadd(
      {required String locationpath, required File file}) async {
    final storage = FirebaseStorage.instance;

    await storage.ref(locationpath).putFile(file);
  }

  static Future<void> bukcetdelete({required String locationpath}) async {
    final storage = FirebaseStorage.instance;

    await storage.ref(locationpath).delete();
  }

  static Future<String> bukcetgetlink(
      {
      required String child1,
      required String child2,
      required Uint8List file}) async {
    final snap = await FirebaseStorage.instance
        .ref()
        .child(child1)
        .child(child2)
        .putData(file);

 

    final String link = await snap.ref.getDownloadURL();

    return link;
  }

  static Future<void> bukcetadddata(
      {required String locationpath, required String data}) async {
    final storage = FirebaseStorage.instance;

    await storage.ref(locationpath).putString(data);
  }
}
