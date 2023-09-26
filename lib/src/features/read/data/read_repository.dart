import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/domain/app_user.dart';
import 'package:starter_architecture_flutter_firebase/src/features/read/domain/read.dart';

class ReadRepository{
  const ReadRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String datesPath(String uid) => 'users/$uid/dates';

  Future<void> addDate(
      {required UserID uid,
        required String date}) =>
      _firestore.collection(datesPath(uid)).add({
        'date': date,
      });

  // delete
  Future<void> deleteDate({required UserID uid, required String date}) async {
    // delete where keep.keepId == keep.keepId
    final datesRef = _firestore.collection(datesPath(uid));
    final dates = await datesRef.get();
    for (final snapshot in dates.docs) {
      final date = date.fromMap(snapshot.data(), 'date');
      if (date.id == date) {
        await snapshot.reference.delete();
      }
    }
    // delete keep
    final keepRef = _firestore.doc(keepPath(uid, keepId));
    await keepRef.delete();
  }
}