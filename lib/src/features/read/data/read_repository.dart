import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hntd/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:hntd/src/features/authentication/domain/app_user.dart';
import 'package:hntd/src/features/read/domain/read.dart';

class ReadRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String datesPath(String uid) => 'users/$uid/dates';

  Future<void> addDate({required UserID uid, required String date}) =>
      _firestore.collection(datesPath(uid)).add({
        'date': date,
      });
}
