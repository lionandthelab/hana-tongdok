import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hntd/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:hntd/src/features/authentication/domain/app_user.dart';
import 'package:hntd/src/features/keeps/domain/keep.dart';

part 'keeps_repository.g.dart';

class KeepsRepository {
  const KeepsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String keepPath(String uid, String keepId) =>
      'users/$uid/keeps/$keepId';
  static String keepsPath(String uid) => 'users/$uid/keeps';

  // create
  Future<void> addKeep(
          {required UserID uid,
          required String title,
          required String verse,
          required String note}) =>
      _firestore.collection(keepsPath(uid)).add({
        'title': title,
        'verse': verse,
        'note': note,
      });

  // update
  Future<void> updateKeep({required UserID uid, required Keep keep}) =>
      _firestore.doc(keepPath(uid, keep.id)).update(keep.toMap());

  // delete
  Future<void> deleteKeep({required UserID uid, required KeepID keepId}) async {
    // delete where keep.keepId == keep.keepId
    final keepsRef = _firestore.collection(keepsPath(uid));
    final keeps = await keepsRef.get();
    for (final snapshot in keeps.docs) {
      final keep = Keep.fromMap(snapshot.data(), snapshot.id);
      if (keep.id == keepId) {
        await snapshot.reference.delete();
      }
    }
    // delete keep
    final keepRef = _firestore.doc(keepPath(uid, keepId));
    await keepRef.delete();
  }

  // read
  Stream<Keep> watchKeep({required UserID uid, required KeepID keepId}) =>
      _firestore
          .doc(keepPath(uid, keepId))
          .withConverter<Keep>(
            fromFirestore: (snapshot, _) =>
                Keep.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (keep, _) => keep.toMap(),
          )
          .snapshots()
          .map((snapshot) => snapshot.data()!);

  Stream<List<Keep>> watchKeeps({required UserID uid}) => queryKeeps(uid: uid)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Query<Keep> queryKeeps({required UserID uid}) =>
      _firestore.collection(keepsPath(uid)).withConverter(
            fromFirestore: (snapshot, _) =>
                Keep.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (keep, _) => keep.toMap(),
          );

  Future<List<Keep>> fetchKeeps({required UserID uid}) async {
    final keeps = await queryKeeps(uid: uid).get();
    return keeps.docs.map((doc) => doc.data()).toList();
  }
}

// Custom methods for the Keeping verses feature
@Riverpod(keepAlive: true)
KeepsRepository keepsRepository(KeepsRepositoryRef ref) {
  return KeepsRepository(FirebaseFirestore.instance);
}

@riverpod
Query<Keep> keepsQuery(KeepsQueryRef ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(keepsRepositoryProvider);
  return repository.queryKeeps(uid: user.uid);
}

@riverpod
Stream<Keep> keepStream(KeepStreamRef ref, KeepID keepId) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(keepsRepositoryProvider);
  return repository.watchKeep(uid: user.uid, keepId: keepId);
}
