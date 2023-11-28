import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hntd/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:hntd/src/features/keeps/data/keeps_repository.dart';
import 'package:hntd/src/features/keeps/domain/keep.dart';

part 'keeps_list_controller.g.dart';

@riverpod
class KeepsListController extends _$KeepsListController {
  @override
  FutureOr<void> build() {
    // ok to leave this empty if the return type is FutureOr<void>
  }

  Future<void> deleteKeep(KeepID keepId) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    final repository = ref.read(keepsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => repository.deleteKeep(uid: currentUser.uid, keepId: keepId));
  }
}
